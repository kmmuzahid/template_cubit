/*
 * @Author: Km Muzahid
 * @Date: 2026-02-25 15:17:12
 * @Email: km.muzahid@gmail.com
 */
import 'package:cubit_template/config/bloc/cubit_scope_value.dart';
import 'package:cubit_template/config/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleTheme extends StatelessWidget {
  const ToggleTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return CubitScopeValue(
      cubit: context.read<ThemeCubit>(),
      builder: (context, cubit, state) {
        return SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(value: 'Light', label: Text('Light')),
            ButtonSegment<String>(value: 'Dark', label: Text('Dark')),
          ],
          selected: <String>{state == ThemeMode.dark ? 'Dark' : 'Light'},
          onSelectionChanged: (value) {
            cubit.toggleTheme();
          },
        );
      },
    );
  }
}
