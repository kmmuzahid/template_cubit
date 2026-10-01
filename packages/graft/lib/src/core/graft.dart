import 'package:flutter/foundation.dart';
import 'graft_change.dart';
import 'graft_observer.dart';

/// Base class for reactive state management with fine-grained slot isolation.
///
/// A [Graft] manages a single, immutable domain state of type [S].
/// UI widgets can reactively listen to [state] or slot-diff children with 0-rebuild isolation.
abstract class Graft<S> {
  /// Global observer for monitoring all [Graft] instances.
  static GraftObserver? observer;

  late S _state;
  late final ValueNotifier<S> _notifier;
  bool _isDisposed = false;

  /// Creates a new [Graft] with the given [initialState].
  Graft(S initialState) {
    _state = initialState;
    _notifier = ValueNotifier<S>(initialState);
    observer?.onCreate(this);
  }

  /// The current state of this [Graft].
  S get state => _state;

  /// A listenable representation of this [Graft]'s state.
  ValueListenable<S> get listenable => _notifier;

  /// Whether this [Graft] has been disposed.
  bool get isDisposed => _isDisposed;

  /// Adds a listener to be notified whenever [state] changes.
  void addListener(VoidCallback listener) {
    if (!_isDisposed) {
      _notifier.addListener(listener);
    }
  }

  /// Removes a previously registered listener.
  void removeListener(VoidCallback listener) {
    if (!_isDisposed) {
      _notifier.removeListener(listener);
    }
  }

  /// Updates the state to [newState] and notifies all listeners.
  ///
  /// If [newState] is equal to current [state] (via `operator ==`),
  /// or if this [Graft] is disposed, this operation is a no-op.
  @protected
  void emit(S newState) {
    if (_isDisposed) {
      if (kDebugMode) {
        debugPrint(
          'Warning: Cannot emit new state ($newState) on a disposed Graft ($runtimeType).',
        );
      }
      return;
    }

    if (_state == newState) {
      return;
    }

    final previousState = _state;
    _state = newState;

    final change = GraftChange<S>(
      currentState: previousState,
      nextState: newState,
    );

    observer?.onChange(this, change);
    _notifier.value = newState;
  }

  /// Reports an error to the global [observer].
  @protected
  void addError(Object error, [StackTrace? stackTrace]) {
    observer?.onError(this, error, stackTrace ?? StackTrace.current);
  }

  /// Disposes this [Graft], releasing all listeners and internal resources.
  @mustCallSuper
  void dispose() {
    if (_isDisposed) return;

    observer?.onDispose(this);
    _isDisposed = true;
    _notifier.dispose();
  }
}
