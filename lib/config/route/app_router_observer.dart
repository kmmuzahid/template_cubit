import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class LogColor {
  static const reset = '\x1B[0m';
  static const bold = '\x1B[1m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const magenta = '\x1B[35m';
  static const cyan = '\x1B[36m';
}

class AppRouterObserver extends AutoRouteObserver {
  /// Converts "HomeRoute" → "HomeScreen.dart"
  String _screenFileName(Route route) {
    final name = route.settings.name ?? 'UnknownRoute';
    return '${name.replaceAll("Route", "Screen")}.dart';
  }

  void _log(String message) {
    // Uses print so it's completely plug-and-play.
    print(message);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final routeName = route.settings.name ?? 'UnknownRoute';
    final screen = _screenFileName(route);

    _log(
      '${LogColor.bold}${LogColor.yellow}[📱 SCREEN PUSH]${LogColor.reset} | '
      '${LogColor.cyan}Route: $routeName${LogColor.reset} | '
      '${LogColor.magenta}Page: $screen${LogColor.reset}',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final routeName = route.settings.name ?? 'UnknownRoute';
    final screen = _screenFileName(route);

    _log(
      '${LogColor.bold}${LogColor.yellow}[⬅️  SCREEN POP]${LogColor.reset} | '
      '${LogColor.cyan}Route: $routeName${LogColor.reset} | '
      '${LogColor.magenta}Page: $screen${LogColor.reset}',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final oldName = oldRoute?.settings.name ?? 'UnknownRoute';
    final newName = newRoute?.settings.name ?? 'UnknownRoute';

    _log(
      '${LogColor.bold}${LogColor.yellow}[🔁 SCREEN REPLACE]${LogColor.reset} | '
      '${LogColor.red}OLD: $oldName${LogColor.reset} | '
      '${LogColor.green}NEW: $newName${LogColor.reset}',
    );
  }
}
