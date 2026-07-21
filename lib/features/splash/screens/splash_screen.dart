import 'package:auto_route/annotations.dart';
import 'package:cubit_template/config/bloc/cubit_scope.dart';
import 'package:cubit_template/features/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CubitScope(
        create: () => SplashCubit()..init(),
        builder: (context, cubit, state) {
          if (state) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
