import '../core/graft.dart';

/// Type-safe factory registry for resolving [Graft] instances.
class GraftRegistry {
  GraftRegistry._();

  static final Map<Type, Object Function()> _factories = {};
  static final Map<Type, Graft> _singletons = {};
  static final Set<Type> _isNewCreateDisabled = {};

  /// Optional fallback resolver (e.g. `GetIt.I<T>`).
  static T Function<T extends Object>()? fallbackLocator;

  /// Registers a factory for a given [Graft] type [T].
  ///
  /// - When [allowNew] is `true` (default):
  ///   The Graft is **Route-Scoped**. It is created on the first screen that calls
  ///   `context.use<T>()`, inherited by pushed routes in the stack, and automatically
  ///   disposed when the owner route pops. Fresh instances can also be created via `context.create<T>()`.
  ///
  /// - When [allowNew] is `false`:
  ///   The Graft is locked as a **Global Singleton**:
  ///   1. Only one instance is ever created for the entire application.
  ///   2. Neither `context.use<T>()` nor `context.create<T>()` will ever create a new instance;
  ///      they will always return this exact shared instance.
  ///   3. It is **never disposed** by any route pop!
  ///
  /// Example:
  /// ```dart
  /// // Route-scoped (default):
  /// GraftRegistry.register(UserGraft.new);
  /// ```
  static void register<T extends Graft>(
    T Function() factory, {
    bool allowNew = true,
  }) {
    _factories[T] = factory;
    if (!allowNew) {
      _isNewCreateDisabled.add(T);
    } else {
      _isNewCreateDisabled.remove(T);
      _singletons.remove(T)?.dispose();
    }
  }

  /// Registers a factory for a given [Graft] type [T] as a **Global Singleton**.
  ///
  /// - [lazy]: If `true` (default), the instance is created lazily on first access
  ///   when `context.use<T>()` is called. If `false`, it is instantiated immediately.
  /// - A singleton is **never re-created** by `context.create<T>()` and is **never disposed** by route pops.
  ///
  /// Example:
  /// ```dart
  /// // Lazy singleton (instantiated on first use):
  /// GraftRegistry.registerSingleton(AuthGraft.new);
  ///
  /// // Eager singleton (instantiated immediately right now):
  /// GraftRegistry.registerSingleton(AuthGraft.new, lazy: false);
  /// ```
  static void registerSingleton<T extends Graft>(
    T Function() factory, {
    bool lazy = true,
  }) {
    register<T>(factory, allowNew: false);
    if (!lazy) {
      getOrCreateSingleton<T>();
    }
  }

  /// Whether new instances can be created for [T]. Returns `false` if registered as singleton.
  static bool canCreateNew<T extends Graft>() {
    return !_isNewCreateDisabled.contains(T);
  }

  /// Returns the singleton instance for [T], creating it on first access if lazy.
  static T getOrCreateSingleton<T extends Graft>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    final instance = create<T>();
    _singletons[T] = instance;
    return instance;
  }

  /// Unregisters a factory for a given [Graft] type [T].
  static void unregister<T extends Graft>() {
    _factories.remove(T);
    _isNewCreateDisabled.remove(T);
    _singletons.remove(T)?.dispose();
  }

  /// Checks if a factory for [T] is registered.
  static bool isRegistered<T extends Graft>() {
    return _factories.containsKey(T);
  }

  /// Creates a new instance of [T] using its registered factory or fallback locator.
  static T create<T extends Graft>() {
    final factory = _factories[T];
    if (factory != null) {
      return factory() as T;
    }

    if (fallbackLocator != null) {
      try {
        return fallbackLocator!<T>();
      } catch (_) {
        // Fall through to descriptive StateError
      }
    }

    throw StateError(
      'Graft of type $T is not registered in GraftRegistry.\n'
      'Please register it at app startup:\n'
      '  GraftRegistry.register<$T>($T.new);\n'
      'Then in your screen simply call:\n'
      '  context.use<$T>();',
    );
  }

  /// Clears all registered factories and singletons. Useful for test teardown.
  static void reset() {
    _factories.clear();
    for (final singleton in _singletons.values) {
      if (!singleton.isDisposed) {
        singleton.dispose();
      }
    }
    _singletons.clear();
    _isNewCreateDisabled.clear();
    fallbackLocator = null;
  }
}
