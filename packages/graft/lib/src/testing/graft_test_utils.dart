import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import '../core/graft.dart';
import '../core/graft_state.dart';

/// Declarative testing utility for [Graft], modeled after `blocTest`.
///
/// Executes pure Dart unit tests with synchronous precision and sub-millisecond speed.
///
/// Example:
/// ```dart
/// graftTest<UserGraft, UserState>(
///   'emits updated user when called',
///   build: () => UserGraft(),
///   act: (graft) => graft.fetch(),
///   verify: (graft) => expect(graft.state.name, 'Alice'),
/// );
/// ```
void graftTest<G extends Graft<S>, S extends GraftState>(
  String description, {
  required G Function() build,
  void Function(G graft)? setUp,
  FutureOr<void> Function(G graft)? act,
  Duration? wait,
  dynamic Function()? expect,
  void Function(G graft)? verify,
  void Function(G graft)? tearDown,
  dynamic tags,
}) {
  test(
    description,
    () async {
      final states = <S>[];
      final graft = build();

      setUp?.call(graft);

      // Listen for emitted states
      void listener() {
        states.add(graft.state);
      }

      graft.addListener(listener);

      try {
        if (act != null) {
          await act(graft);
        }

        if (wait != null) {
          await Future.delayed(wait);
        }

        if (expect != null) {
          final expected = expect();
          expectLater(states, expected);
        }

        verify?.call(graft);
      } finally {
        graft.removeListener(listener);
        tearDown?.call(graft);
        if (!graft.isDisposed) {
          graft.dispose();
        }
      }
    },
    tags: tags,
  );
}
