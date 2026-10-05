import 'dart:async';

import 'package:graft/graft.dart';

class SplashCubit extends Graft<ChildSplashCubit> {
  SplashCubit() : super(ChildSplashCubit(name: 'Muzahid', time: 1));

  void init() async {
    await Future.delayed(const Duration(seconds: 1));
    state
      ..name = "Km Muzahid"
      ..time = 1
      ..update();

    await Future.delayed(const Duration(seconds: 1));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      state
        ..time += 1
        ..update();
    });
  }
}

class ChildSplashCubit extends GraftState {
  String name;
  int time;

  ChildSplashCubit({required this.name, required this.time});

  @override
  List<Object?> get props => [name, time];
}
