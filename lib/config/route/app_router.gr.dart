// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:cubit_template/features/auth/screens/login_screen.dart' as _i3;
import 'package:cubit_template/features/auth/screens/reset_password_screen.dart'
    as _i4;
import 'package:cubit_template/features/auth/screens/signup_screen.dart' as _i5;
import 'package:cubit_template/features/home/home_screen.dart' as _i1;
import 'package:cubit_template/features/info/cubit/info_state.dart' as _i9;
import 'package:cubit_template/features/info/screens/info_screen.dart' as _i2;
import 'package:cubit_template/features/splash/screens/splash_screen.dart'
    as _i6;
import 'package:material_ui/material_ui.dart' as _i8;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.InfoScreen]
class InfoRoute extends _i7.PageRouteInfo<InfoRouteArgs> {
  InfoRoute({
    _i8.Key? key,
    required _i9.InfoType type,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         InfoRoute.name,
         args: InfoRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'InfoRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoRouteArgs>();
      return _i2.InfoScreen(key: args.key, type: args.type);
    },
  );
}

class InfoRouteArgs {
  const InfoRouteArgs({this.key, required this.type});

  final _i8.Key? key;

  final _i9.InfoType type;

  @override
  String toString() {
    return 'InfoRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.ResetPasswordScreen]
class ResetPasswordRoute extends _i7.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i7.PageRouteInfo>? children})
    : super(ResetPasswordRoute.name, initialChildren: children);

  static const String name = 'ResetPasswordRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i6.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SplashScreen();
    },
  );
}
