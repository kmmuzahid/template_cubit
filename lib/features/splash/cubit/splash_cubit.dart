import 'package:cubit_template/config/bloc/safe_cubit.dart';

class SplashCubit extends SafeCubit<bool> {
  SplashCubit() : super(false);

  void init() async {
    emit(true);
    await Future.delayed(const Duration(seconds: 2));
    emit(false);
  }
}
