import 'package:auto_route/auto_route.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:flutter/material.dart';

class ForgetPasswordDialogContent extends StatelessWidget {
  const ForgetPasswordDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Map<String, dynamic> entityMap = {};

    return CkFormBuilder<Map<String, dynamic>>(
      entity: entityMap,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      builder: (context, formKey, entity) {
        return Padding(
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
                    color: colors.ratingPremiumTags_goldAccent.withValues(
                      alpha: 0.1,
                    ),
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
                text:
                    'Enter your registered email address below to receive a verification OTP code.',
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
                hintText: 'Enter your email',
                validationType: CkValidationType.validateEmail,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colors.tEXT_subDark,
                  size: 20.w,
                ),
                onSaved: (value, controller) => entity['email'] = value,
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
                          onTap: () {
                            if (formKey.validateAndSave()) {
                              final email =
                                  entity['email']?.toString().trim() ?? '';

                              ckDebug('email: $email');
                              context.pop();
                              ckAuth.forgotPassword(body: {'email': email});
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
      },
    );
  }
}
