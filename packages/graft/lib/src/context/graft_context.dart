import 'package:flutter/widgets.dart';
import '../core/graft.dart';
import '../di/graft_registry.dart';
import '../route/graft_route_tracker.dart';

/// Extension on [BuildContext] providing ergonomic Graft lookups and route-stack lifecycle management.
extension GraftContextX on BuildContext {
  /// Resolves a [Graft] of type [T].
  ///
  /// - If [T] was registered with `isNewCreate: false`, returns the permanent
  ///   global singleton (never re-created, never route-disposed).
  /// - Otherwise, searches the current route and active predecessor routes in the navigation stack.
  /// - If an active instance exists, it is reused.
  /// - If not found, a new instance is created and owned by the current route (auto-disposed when owner pops).
  ///
  /// Example:
  /// ```dart
  /// final graft = context.use<InfoGraft>();
  /// ```
  T use<T extends Graft>([T Function()? factory]) {
    // If registered with isNewCreate: false, always return the permanent singleton
    if (!GraftRegistry.canCreateNew<T>()) {
      return GraftRegistry.getOrCreateSingleton<T>();
    }

    final route = ModalRoute.of(this);

    if (route != null) {
      final existing = GraftRouteTracker.findInStack<T>(route);
      if (existing != null) {
        return existing;
      }
    }

    final newInstance = factory != null ? factory() : GraftRegistry.create<T>();

    if (route != null) {
      GraftRouteTracker.registerOwned<T>(route, newInstance);
    }

    return newInstance;
  }

  /// Force-creates a brand-new [Graft] of type [T] owned by the current route.
  ///
  /// - Note: If [T] was registered with `isNewCreate: false`, creating a new instance is
  ///   disabled and this will safely return the permanent singleton instead.
  ///
  /// Example:
  /// ```dart
  /// final graft = context.create<InfoGraft>();
  /// ```
  T create<T extends Graft>([T Function()? factory]) {
    // If registered with isNewCreate: false, new creations are disabled; return singleton
    if (!GraftRegistry.canCreateNew<T>()) {
      return GraftRegistry.getOrCreateSingleton<T>();
    }

    final route = ModalRoute.of(this);
    final newInstance = factory != null ? factory() : GraftRegistry.create<T>();

    if (route != null) {
      GraftRouteTracker.registerOwned<T>(route, newInstance);
    }

    return newInstance;
  }

  /// Looks up an existing [Graft] of type [T] in the current route stack.
  ///
  /// Throws a [StateError] if no instance is active.
  T find<T extends Graft>() {
    if (!GraftRegistry.canCreateNew<T>()) {
      return GraftRegistry.getOrCreateSingleton<T>();
    }

    final route = ModalRoute.of(this);
    final existing = GraftRouteTracker.findInStack<T>(route);

    if (existing != null) {
      return existing;
    }

    throw StateError(
      'Could not find any active Graft of type $T in the route stack.\n'
      'Make sure an ancestor screen called context.use<$T>() or context.create<$T>().',
    );
  }
}
