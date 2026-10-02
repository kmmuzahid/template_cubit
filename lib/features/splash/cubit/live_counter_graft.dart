import 'package:graft/graft.dart';

class LiveCounterState extends GraftState {
  int count;

  LiveCounterState({this.count = 0});
}

class LiveCounterGraft extends Graft<LiveCounterState> {
  LiveCounterGraft() : super(LiveCounterState());

  void increment() {
    state
      ..count += 1
      ..update();
  }

  void reset() {
    state
      ..count = 0
      ..update();
  }
}
