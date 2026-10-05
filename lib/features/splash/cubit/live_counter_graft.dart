import 'package:graft/graft.dart';

class LiveCounterState extends GraftState {
  int count;

  LiveCounterState({this.count = 0});

  @override
  List<Object?> get props => [count];
}

class LiveCounterGraft extends Graft<LiveCounterState> {
  LiveCounterGraft() : super(LiveCounterState());

  void increment() {
    state
      ..count += 1
      ..update();
  }
}
