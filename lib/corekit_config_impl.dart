import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/api/api_end_point.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/config/route/app_router.gr.dart';
import 'package:cubit_template/features/auth/model/profile_model.dart';
import 'package:cubit_template/features/common/widgets/otp_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

CkAuth<ProfileModel> ckAuth = CkAuth();

class CorekitConfigImpl extends CoreKitConfig with CoreKitConfigDefaults {
  @override
  CkAppBarConfig? get appbarConfig => CkAppBarConfig(titleAlignment: .center);

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

  @override
  CkTransportConfig get ckTransportConfig => CkTransportConfig(
    baseUrl: ApiEndPoint.baseUrl,
    refreshTokenEndpoint: '',
    enableDebugLogs: kDebugMode,
  );

  @override
  CkAuthConfig get authConfig => CkAuthConfig(
    mockAuth: true,
    endpoints: CkAuthEndpoints(
      resetPassword: '',
      forgotPassword: '',
      signup: '',
      signin: '',
      sendOtp: '',
      verifyOtp: '',
      getProfile: '',
      updateProfile: '',
      verifyForgetOtp: '',
      logout: "",
      resetPasswordMethod: .PATCH,
      verifyForgotOtpMethod: .PATCH,
      sendOtpMethod: .PATCH,
    ),
    loginBodyBuilder: (LoginCallback loginCallBack) {
      return {
        'email': loginCallBack.username,
        'password': loginCallBack.password,
      };
    },
    extractors: CkAuthExtractors(
      accessToken: (data) => data['accessToken']?.toString(),
      refreshToken: (data) => data['refreshToken']?.toString(),
      resetPasswordToken: (data) => data['forgetOtpMatchToken']?.toString(),
      profile: (data) {
        // final profile = ProfileData.fromJson(data);
        return data;
      },
      message: (data) => data['message']?.toString(),
      verificationTokens: {
        CkOtpTrigger.signup: (data) =>
            data['createUserToken']?.toString() ?? data['token']?.toString(),
        CkOtpTrigger.login: (data) => data['loginUserToken']?.toString(),
        CkOtpTrigger.forgetPassword: (data) => data['forgetToken']?.toString(),
      },
    ),
    otpConfig: CkOtpConfig(
      autoTriggers: {
        CkOtpTrigger.signup,
        CkOtpTrigger.forgetPassword,
        CkOtpTrigger.login,
      },
      verificationStrategy: CkOtpVerificationStrategy.tokenBased,
      verificationTokenHeaderKey: 'token',
      sendVerificationTokenInHeader: true,
      verifyBodyBuilder: (ctx) async {
        return {"otp": ctx.otp};
      },
      resendBodyBuilder: (ctx) {
        return {"email": ctx.identifier};
      },
    ),
    handlers: CkAuthFlowHandlers(
      showResetPassword: () {
        appRouter.replaceAll([const ResetPasswordRoute()]);
      },
      showOtpVerification: () {
        CkDialog(
          context: appRouter.navigatorKey.currentContext!,
          child: OtpDialogContent(),
        );
      },
      onAuthenticated: () {
        ckApiDebug('authenticated');
        appRouter.replaceAll([HomeRoute()]);
      },
      showLogin: () {
        ckApiDebug('showLogin');
        appRouter.replaceAll([LoginRoute()]);
      },
      // showOnboarding: () {
      //   Get.offAllNamed(AppRoute.onboardingscreen);
      // },
    ),
  );
}
