import 'package:flutter/foundation.dart';
import 'graft_change.dart';

/// Global observer interface for monitoring the lifecycle and transitions of all [Graft] instances.
abstract class GraftObserver {
  /// Called immediately when a [Graft] is instantiated.
  void onCreate(dynamic graft) {}

  /// Called whenever a [Graft] emits a new state.
  void onChange(dynamic graft, GraftChange change) {}

  /// Called whenever an unhandled error occurs in a [Graft].
  void onError(dynamic graft, Object error, StackTrace stackTrace) {}

  /// Called immediately before a [Graft] is disposed.
  void onDispose(dynamic graft) {}
}

/// Default development observer with ANSI colorized terminal logs.
class GraftDevObserver extends GraftObserver {
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _green = '\x1B[32m';
  static const _cyan = '\x1B[36m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _magenta = '\x1B[35m';

  @override
  void onCreate(dynamic graft) {
    if (kDebugMode) {
      debugPrint(
        '$_bold$_green[🌱 GRAFT CREATED]$_reset | $_cyan${graft.runtimeType}$_reset',
      );
    }
  }

  @override
  void onChange(dynamic graft, GraftChange change) {
    if (kDebugMode) {
      debugPrint(
        '$_bold$_yellow[⚡ GRAFT CHANGE]$_reset | '
        '$_cyan${graft.runtimeType}$_reset\n'
        '  $_magenta${change.currentState}$_reset\n'
        '  ➡️ $_green${change.nextState}$_reset',
      );
    }
  }

  @override
  void onError(dynamic graft, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint(
        '$_bold$_red[💥 GRAFT ERROR]$_reset | '
        '$_cyan${graft.runtimeType}$_reset: $error\n$stackTrace',
      );
    }
  }

  @override
  void onDispose(dynamic graft) {
    if (kDebugMode) {
      debugPrint(
        '$_bold$_red[🗑️ GRAFT DISPOSED]$_reset | $_cyan${graft.runtimeType}$_reset',
      );
    }
  }
}
