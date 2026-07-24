import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:cubit_template/features/common/widgets/otp_dialog.dart';
import 'package:flutter/material.dart';

class ForgetPasswordDialogContent extends StatelessWidget {
  ForgetPasswordDialogContent({super.key});

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Centered Help Icon
            Center(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colors.ratingPremiumTags_goldAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: colors.ratingPremiumTags_goldAccent,
                  size: 36.w,
                ),
              ),
            ),
            16.height,

            // Title
            CkText(
              text: 'Forgot Password',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: colors.tEXT_white,
              textAlign: TextAlign.center,
            ),
            8.height,

            // Subtitle
            CkText(
              text: 'Enter your registered email address below to receive a verification OTP code.',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: colors.tEXT_subDark,
              textAlign: TextAlign.center,
              isDescription: true,
            ),
            20.height,

            // Email Input Field
            CkText(
              text: 'Email Address',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.tEXT_white,
              textAlign: TextAlign.left,
            ),
            8.height,
            CkTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              validationType: CkValidationType.validateEmail,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: colors.tEXT_subDark,
                size: 20.w,
              ),
            ),
            24.height,

            // Actions Row
            Row(
              children: [
                Expanded(
                  child: CkButton(
                    titleText: 'Cancel',
                    buttonColor: colors.bACKGROUND_darkCardBoarder,
                    titleColor: colors.tEXT_white,
                    buttonRadius: 24.w,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                12.width,
                Expanded(
                  child: ckAuth.loadingUi(
                    type: CkAuthLoadingType.sendOtp,
                    builder: (isLoading) {
                      return CkButton(
                        titleText: 'Send OTP',
                        isLoading: isLoading,
                        buttonColor: colors.ratingPremiumTags_goldAccent,
                        titleColor: colors.bACKGROUND_darkPage,
                        buttonRadius: 24.w,
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final email = _emailController.text.trim();
                            // Set last trigger to forgetPassword so verify/resend OTP knows the context
                            ckAuth.otpManager.lastTrigger = CkOtpTrigger.forgetPassword;
                            
                            final result = await ckAuth.sendOtp(identifier: email);
                            if (result.isSuccess) {
                              if (context.mounted) {
                                Navigator.of(context).pop(); // Dismiss forgot password dialog
                              }
                              CkSnackBar('OTP Code sent successfully!', type: CkSnackBarType.success);
                              
                              // Display the Verification Code dialog
                              CkDialog(
                                context: appRouter.navigatorKey.currentContext!,
                                child: OtpDialogContent(),
                              );
                            } else {
                              CkSnackBar(result.message ?? 'Failed to send OTP', type: CkSnackBarType.error);
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
