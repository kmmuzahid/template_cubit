import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin AppbarConfig on CoreKitConfig {
  @override
  CkAppBarConfig? get appbarConfig => CkAppBarConfig(
        titleAlignment: Alignment.center,
      );
}
