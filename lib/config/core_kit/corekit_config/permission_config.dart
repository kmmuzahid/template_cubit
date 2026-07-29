import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin PermissionConfig on CoreKitConfig {
  @override
  CkPermissionHelperConfig? get permissionHelperConfig => const CkPermissionHelperConfig(
        // permissionDenied: 'Permission Denied',
        // openSettings: 'Open Settings',
        // cancel: 'Cancel',
        // permissionIsPermanentlyDenied: 'Permission is permanently denied.',
        // toFixThisPleaseGoTo: 'To fix this, please go to ',
        // andAllowThePermissionManually: 'and allow the permission manually.',
      );

  @override
  PermissionHadlerColors? get permissionHandlerColors => PermissionHadlerColors(
        errorColor: Colors.red,
        actionColor: Colors.green,
        normalColor: Colors.black,
      );
}
