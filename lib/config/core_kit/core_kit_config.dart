import 'dart:ui';

import 'package:core_kit/core_kit.dart';
import 'package:cubit_template/config/api/api_end_point.dart';
import 'package:cubit_template/config/core_kit/corekit_config/appbar_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/auth_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/input_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/list_loader_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/password_obscure_icon_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/permission_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/snackbar_config.dart';
import 'package:cubit_template/config/core_kit/corekit_config/transport_config.dart';
import 'package:cubit_template/features/auth/model/profile_model.dart';

CkAuth<ProfileModel> ckAuth = CkAuth();

class AppCoreKitConfig extends CoreKitConfig
    with
        AuthConfig,
        AppbarConfig,
        InputConfig,
        SnackBarConfig,
        ListLoaderConfig,
        PermissionConfig,
        PasswordObscureIconConfig,
        TransportConfig {
  @override
  Size get designSize => const Size(428, 926);

  @override
  String get imageBaseUrl => ApiEndPoint.domain;

  /// Disable enforced splash delay for faster navigation
  @override
  int get splashDelayMs => 3000;

  /// Custom initialization tasks run during the 3-second splash delay.
  /// Use this to register dependencies, initialize services, etc.
  @override
  Future<void> Function()? get onInit => () async {
    //if app installed first time then delete.
    //save it in flutter shared preferese.
  };
}
