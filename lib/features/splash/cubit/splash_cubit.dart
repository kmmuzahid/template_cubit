import 'package:graft/graft.dart';

class SplashCubit extends ValueGraft<bool> {
  SplashCubit() : super(false);

  void init() async {
    value = true;
    await Future.delayed(const Duration(seconds: 2));
    value = false;
  }
}
