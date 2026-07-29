import 'package:core_kit/core_kit.dart';
import 'package:cubit_template/config/api/api_end_point.dart';
import 'package:flutter/foundation.dart';

mixin TransportConfig on CoreKitConfig {
  @override
  CkTransportConfig get ckTransportConfig => CkTransportConfig(
        baseUrl: ApiEndPoint.baseUrl,
        refreshTokenEndpoint: '',
        enableDebugLogs: kDebugMode,
      );
}
