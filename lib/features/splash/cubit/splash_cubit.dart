import 'package:graft/graft.dart';

class SplashCubit extends Graft<bool> {
  SplashCubit() : super(false);

  void init() async {
    emit(true);
    await Future.delayed(const Duration(seconds: 2));
    emit(false);
  }
}
