import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin InputConfig on CoreKitConfig {
  @override
  CkInputConfig? get inputConfig => const CkInputConfig(
        // hintStyle: TextStyle(color: Colors.grey),
        // textStyle: TextStyle(color: Colors.black),
        // fontSize: 16.0,
        // textAlign: TextAlign.left,
        // borderColor: Colors.grey,
        // borderRadius: 12.0,
        // borderWidth: 1.2,
        // backgroundColor: Colors.white,
        // enableCapitalization: true,
      );
}
