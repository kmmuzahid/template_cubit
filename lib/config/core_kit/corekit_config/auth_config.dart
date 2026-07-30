import 'package:core_kit/auth/ck_auth_config.dart';
import 'package:core_kit/auth/ck_auth_endpoints.dart';
import 'package:core_kit/auth/ck_auth_extractors.dart';
import 'package:core_kit/auth/ck_auth_flow_handlers.dart';
import 'package:core_kit/auth/otp/otp_config.dart';
import 'package:core_kit/dialog/ck_dialog.dart';
import 'package:core_kit/initializer.dart';
import 'package:core_kit/utils/ck_logger.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/config/route/app_router.gr.dart';
import 'package:cubit_template/features/common/widgets/otp_dialog.dart';

mixin AuthConfig on CoreKitConfig {
  @override
  CkAuthConfig get authConfig => CkAuthConfig(
    mockAuth: true,
    endpoints: _endpoints(),

    loginRequestBuilder: (LoginCallback loginCallBack) {
      return CkLoginRequest(
        body: {
          'email': loginCallBack.account,
          'password': loginCallBack.password,
        },
      );
    },
    extractors: _extractors(),
    otpConfig: _otpConfig(),
    handlers: _authFlowHandlers(),
  );

  CkAuthEndpoints _endpoints() {
    return CkAuthEndpoints(
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
    );
  }

  CkAuthExtractors _extractors() {
    return CkAuthExtractors(
      accessToken: (data) => data['accessToken']?.toString(),
      refreshToken: (data) => data['refreshToken']?.toString(),
      resetPasswordToken: (data) => data['forgetOtpMatchToken']?.toString(),
      profile: (data) {
        return data;
      },
      message: (data) => data['message']?.toString(),
      verificationTokens: {
        CkOtpTrigger.signup: (data) =>
            data['createUserToken']?.toString() ?? data['token']?.toString(),
        CkOtpTrigger.login: (data) => data['loginUserToken']?.toString(),
        CkOtpTrigger.forgetPassword: (data) => data['forgetToken']?.toString(),
      },
    );
  }

  CkAuthFlowHandlers _authFlowHandlers() {
    return CkAuthFlowHandlers(
      showResetPassword: () {
        appRouter.replaceAll([const ResetPasswordRoute()]);
      },
      showOtpVerification: () {
        ckDebug('dsafhasjdfhjdsfh');
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
    );
  }

  CkOtpConfig _otpConfig() {
    return CkOtpConfig(
      autoTriggers: {CkOtpTrigger.signup, CkOtpTrigger.forgetPassword},
      resendCooldown: Duration(seconds: 60),
      verificationStrategy: CkOtpVerificationStrategy.tokenBased,
      verificationTokenHeaderKey: 'token',
      sendVerificationTokenInHeader: true,
      verifyBodyBuilder: (ctx) async {
        return {"otp": ctx.otp};
      },
      resendBodyBuilder: (ctx) {
        return {"email": ctx.recipient};
      },
    );
  }
}
