import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin PasswordObscureIconConfig on CoreKitConfig {
  @override
  PasswordObscureIcon? get passwordObscureIcon => PasswordObscureIcon(
        show: const Icon(Icons.visibility, size: 20),
        hide: const Icon(Icons.visibility_off, size: 20),
        // padding: const EdgeInsetsDirectional.only(end: 10),
      );
}
