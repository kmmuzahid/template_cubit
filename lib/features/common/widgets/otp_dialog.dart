import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:flutter/material.dart';

class OtpDialogContent extends StatefulWidget {
  const OtpDialogContent({super.key});

  @override
  State<OtpDialogContent> createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<OtpDialogContent> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Centered Gold Lock Icon
          Center(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.ratingPremiumTags_goldAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_outlined,
                color: colors.ratingPremiumTags_goldAccent,
                size: 36.w,
              ),
            ),
          ),
          16.height,

          // Title
          CkText(
            text: 'Enter verification code',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.tEXT_white,
            textAlign: TextAlign.center,
          ),
          8.height,

          // Subtitle
          CkText(
            text: 'Please enter the 6-digit verification code sent to your device.',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            textColor: colors.tEXT_subDark,
            textAlign: TextAlign.center,
            isDescription: true,
          ),
          20.height,

          // Center-aligned numeric entry field
          CkTextField(
            controller: _otpController,
            hintText: '• • • • • •',
            validationType: CkValidationType.notRequired,
            maxLength: 6,
            textAlign: TextAlign.center,
            fontSize: 22,
            textStyle: TextStyle(
              fontSize: 24,
              letterSpacing: 10,
              fontWeight: FontWeight.bold,
              color: colors.tEXT_white,
            ),
          ),
          16.height,

          // Resend Timer Row
          ckAuth.otpCountdownUi(
            builder: (seconds) {
              if (seconds > 0) {
                return CkText(
                  text: 'Resend code in ${seconds}s',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: colors.tEXT_subDark,
                  textAlign: TextAlign.center,
                );
              } else {
                return Center(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await ckAuth.sendOtp();
                      if (result.isSuccess) {
                        CkSnackBar('OTP Resent Successfully', type: CkSnackBarType.success);
                      } else {
                        CkSnackBar(result.message ?? 'Failed to resend OTP', type: CkSnackBarType.error);
                      }
                    },
                    child: CkText(
                      text: 'Resend Code',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.ratingPremiumTags_goldAccent,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
          24.height,

          // Action Buttons
          Row(
            children: [
              // Cancel Button
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
              // Verify Button
              Expanded(
                child: ckAuth.loadingUi(
                  type: CkAuthLoadingType.verifyOtp,
                  builder: (isLoading) {
                    return CkButton(
                      titleText: 'Verify',
                      isLoading: isLoading,
                      buttonColor: colors.ratingPremiumTags_goldAccent,
                      titleColor: colors.bACKGROUND_darkPage,
                      buttonRadius: 24.w,
                      onTap: () async {
                        final code = _otpController.text.trim();
                        if (code.length < 4) {
                          CkSnackBar('Please enter a valid OTP', type: CkSnackBarType.warning);
                          return;
                        }

                        final result = await ckAuth.verifyOtp(otp: code);
                        if (result.isSuccess) {
                          if (mounted) {
                            Navigator.of(context).pop(); // close dialog
                          }
                          CkSnackBar('Verification successful!', type: CkSnackBarType.success);
                        } else {
                          CkSnackBar(result.message ?? 'Verification failed', type: CkSnackBarType.error);
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
    );
  }
}
