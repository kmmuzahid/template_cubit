import 'package:flutter/foundation.dart';
import 'graft_change.dart';
import 'graft_observer.dart';
import 'graft_state.dart';

/// Internal notifier that allows forcing notifications even when mutating state in-place.
class _GraftNotifier<T> extends ValueNotifier<T> {
  _GraftNotifier(super.value);

  void forceNotify() {
    notifyListeners();
  }
}

/// Base class for reactive state management with fine-grained slot isolation.
///
/// A [Graft] manages domain state of type [S], which must extend [GraftState].
/// Supports mutable cascade updates via [GraftState] (`state..name = ''..update()`).
abstract class Graft<S extends GraftState> {
  /// Global observer for monitoring all [Graft] instances.
  static GraftObserver? observer;

  late S _state;
  late final _GraftNotifier<S> _notifier;
  bool _isDisposed = false;

  /// Creates a new [Graft] with the given [initialState].
  Graft(S initialState) {
    _state = initialState;
    _notifier = _GraftNotifier<S>(initialState);
    initialState.bindGraft(this);
    observer?.onCreate(this);
  }

  /// The current state of this [Graft].
  S get state => _state;

  /// Directly sets the next state and notifies listeners.
  set state(S newState) => emit(newState);

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

  /// Notifies all listeners and triggers fine-grained slot diffing for [state].
  ///
  /// Typically called automatically by `state..update()` when using [GraftState].
  void notify() {
    if (_isDisposed) {
      if (kDebugMode) {
        debugPrint(
          'Warning: Cannot notify on a disposed Graft ($runtimeType).',
        );
      }
      return;
    }

    final change = GraftChange<S>(
      currentState: _state,
      nextState: _state,
    );

    observer?.onChange(this, change);
    _notifier.forceNotify();
  }

  /// Updates the state to [newState] and notifies all listeners.
  ///
  /// If [newState] is identical to current [state], [notify] is called.
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
    newState.bindGraft(this);

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
