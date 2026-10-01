import 'graft.dart';

/// Base class for domain states that enables direct cascade mutation with zero boilerplate.
///
/// Example:
/// ```dart
/// class UserState extends GraftState {
///   String name = '';
///   String lastname = '';
///   bool isLoading = false;
/// }
///
/// class UserGraft extends Graft<UserState> {
///   UserGraft() : super(UserState());
///
///   void updateUser() {
///     state
///       ..name = 'Alice'
///       ..lastname = 'Smith'
///       ..isLoading = false
///       ..update(); // Triggers batched slot diffing!
///   }
/// }
/// ```
abstract class GraftState {
  Graft? _graft;

  /// Internal hook called by [Graft] constructor to bind this state to its controller.
  void bindGraft(Graft graft) {
    _graft = graft;
  }

  /// Triggers fine-grained slot diffing and notifies all listeners of changes.
  void update() {
    _graft?.notify();
  }
}
