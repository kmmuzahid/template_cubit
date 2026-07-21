/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 12:29:06
 * @Email: km.muzahid@gmail.com
 */
import 'package:core_kit/core_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    } else {
      ckWarning('Cubit is closed, cannot emit state.', tag: 'Safe Cubit');
    }
  }
}
