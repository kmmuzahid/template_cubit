/*
 * @Author: Km Muzahid
 * @Date: 2026-02-25 15:05:29
 * @Email: km.muzahid@gmail.com
 */
import 'package:cubit_template/config/bloc/safe_cubit.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends SafeCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }
}
