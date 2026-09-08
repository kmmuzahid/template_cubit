import 'package:core_kit/core_kit.dart';
import 'package:material_ui/material_ui.dart';

mixin AppbarConfig on CoreKitConfig {
  @override
  CkAppBarConfig? get appbarConfig => CkAppBarConfig(
        titleAlignment: Alignment.center,
      );
}
