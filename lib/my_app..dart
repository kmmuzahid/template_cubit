/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 15:37:37
 * @Email: km.muzahid@gmail.com
 */
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/config/route/app_router_observer.dart';
import 'package:cubit_template/config/theme/cubit/theme_cubit.dart';
import 'package:cubit_template/config/theme/custom_theme.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // or ClampingScrollPhysics, etc.
  }

  @override
  ScrollViewKeyboardDismissBehavior getKeyboardDismissBehavior(
    BuildContext context,
  ) {
    return ScrollViewKeyboardDismissBehavior.onDrag;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(), lazy: false),

        // BlocProvider(create: (_) => LanguageCubit()..init(), lazy: false),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          return CoreKit.router(
            config: CorekitConfigImpl(),
            navigatorKey: appRouter.navigatorKey,
            scrollBehavior: CustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.config(
              navigatorObservers: () => [AppRouterObserver()],
            ),
            theme: commonThemeData(ThemeColor.light),
            darkTheme: commonThemeData(ThemeColor.dark),
            themeMode: themeState,
          );
        },
      ),
    );
  }
}
