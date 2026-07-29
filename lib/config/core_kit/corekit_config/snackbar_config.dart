import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin SnackBarConfig on CoreKitConfig {
  @override
  CkSnackBarConfig? get snackBarConfig => const CkSnackBarConfig(
        position: CkSnackBarPosition.bottom,
        borderRadius: 12.0,
        // backgroundColor: Colors.white,
        // margin: EdgeInsets.all(16),
        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        // textStyle: TextStyle(color: Colors.black),
        // borderWidthLeft: 10,
        // borderWidthOthers: 1,
        // iconSize: 24,
        // successColor: Colors.green,
        // errorColor: Colors.red,
        // warningColor: Colors.orange,
        // infoColor: Colors.blue,
      );
}
