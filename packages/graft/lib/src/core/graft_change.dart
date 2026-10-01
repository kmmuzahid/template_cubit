/// Represents a state transition in a [Graft].
class GraftChange<S> {
  /// The state before the transition.
  final S currentState;

  /// The state after the transition.
  final S nextState;

  const GraftChange({
    required this.currentState,
    required this.nextState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraftChange<S> &&
          runtimeType == other.runtimeType &&
          currentState == other.currentState &&
          nextState == other.nextState;

  @override
  int get hashCode => currentState.hashCode ^ nextState.hashCode;

  @override
  String toString() => 'GraftChange(current: $currentState, next: $nextState)';
}
