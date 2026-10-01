import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graft/graft.dart';
import 'package:graft/testing.dart';

class CounterState extends Equatable {
  final int count;
  const CounterState(this.count);

  @override
  List<Object?> get props => [count];
}

class CounterGraft extends Graft<CounterState> {
  CounterGraft() : super(const CounterState(0));

  void increment() => emit(CounterState(state.count + 1));
  void add(int amount) => emit(CounterState(state.count + amount));

  Future<void> delayedIncrement() async {
    await Future.delayed(const Duration(milliseconds: 50));
    increment();
  }
}

void main() {
  group('graftTest Harness Tests', () {
    graftTest<CounterGraft, CounterState>(
      'emits [CounterState(1)] when increment is called',
      build: () => CounterGraft(),
      act: (graft) => graft.increment(),
      expect: () => [
        const CounterState(1),
      ],
    );

    graftTest<CounterGraft, CounterState>(
      'emits multiple states in correct order',
      build: () => CounterGraft(),
      act: (graft) {
        graft.increment();
        graft.add(5);
      },
      expect: () => [
        const CounterState(1),
        const CounterState(6),
      ],
    );

    graftTest<CounterGraft, CounterState>(
      'supports async delays with wait parameter',
      build: () => CounterGraft(),
      act: (graft) => graft.delayedIncrement(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const CounterState(1),
      ],
    );
  });
}
