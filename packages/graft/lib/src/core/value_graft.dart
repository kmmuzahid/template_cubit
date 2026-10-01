import 'graft.dart';
import 'graft_state.dart';

/// Single-value state container that extends [GraftState].
class GraftValue<T> extends GraftState {
  T value;

  GraftValue(this.value);

  @override
  String toString() => value.toString();
}

/// A specialized [Graft] for managing single primitive or enum values without writing a custom state class.
///
/// Example:
/// ```dart
/// class CounterGraft extends ValueGraft<int> {
///   CounterGraft() : super(0);
///
///   void increment() => value++;
///   void decrement() => value--;
/// }
///
/// class ThemeGraft extends ValueGraft<ThemeMode> {
///   ThemeGraft() : super(ThemeMode.system);
///
///   void setMode(ThemeMode mode) => value = mode;
/// }
/// ```
abstract class ValueGraft<T> extends Graft<GraftValue<T>> {
  /// Creates a [ValueGraft] with the given [initialValue].
  ValueGraft(T initialValue) : super(GraftValue<T>(initialValue));

  /// The current primitive value.
  T get value => state.value;

  /// Updates the value and triggers fine-grained reactive rebuilds.
  ///
  /// If [newValue] is equal to current [value], this operation is a no-op.
  set value(T newValue) {
    if (state.value == newValue) return;
    state.value = newValue;
    state.update();
  }
}
