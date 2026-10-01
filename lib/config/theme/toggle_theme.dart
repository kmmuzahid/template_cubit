import 'package:cubit_template/config/theme/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ToggleTheme extends StatelessWidget {
  const ToggleTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(value: 'Light', label: Text('Light')),
            ButtonSegment<String>(value: 'Dark', label: Text('Dark')),
          ],
          selected: <String>{state == ThemeMode.dark ? 'Dark' : 'Light'},
          onSelectionChanged: (value) {
            context.read<ThemeCubit>().toggleTheme();
          },
        );
      },
    );
  }
}
