import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/config/route/app_router.gr.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:cubit_template/features/common/widgets/app_screen_layout.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Map<String, dynamic> entityMap = {};

    return AppScreenLayout(
      appBar: const CkAppBar(
        title: 'Reset Password',
        hideBack: true,
      ),
      body: SingleChildScrollView(
        child: CkFormBuilder<Map<String, dynamic>>(
          entity: entityMap,
          builder: (context, formKey, entity) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.height,
                // Header text
                CkText(
                  text: 'Define New Password',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  textColor: colors.tEXT_white,
                  textAlign: TextAlign.left,
                ),
                8.height,
                CkText(
                  text: 'Create a new secure password for your account.',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: colors.tEXT_subDark,
                  textAlign: TextAlign.left,
                  isDescription: true,
                ),
                30.height,

                // Inputs Card
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: colors.bACKGROUND_darkCard,
                    borderRadius: BorderRadius.circular(16.w),
                    border: Border.all(
                      color: colors.bACKGROUND_darkCardBoarder,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // New Password Field
                      CkText(
                        text: 'New Password',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkTextField(
                        hintText: 'Enter new password',
                        validationType: CkValidationType.validatePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        onChanged: (value) => entity['password'] = value,
                      ),
                      16.height,

                      // Confirm Password Field
                      CkText(
                        text: 'Confirm Password',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkTextField(
                        hintText: 'Re-enter new password',
                        validationType: CkValidationType.validateConfirmPassword,
                        prefixIcon: Icon(
                          Icons.lock_reset,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        originalPassword: () => entity['password']?.toString() ?? '',
                      ),
                      24.height,

                      // Submit Button
                      ckAuth.loadingUi(
                        type: CkAuthLoadingType.updatePassword,
                        builder: (isLoading) {
                          return CkButton(
                            titleText: 'Update Password',
                            isLoading: isLoading,
                            buttonRadius: 30.w,
                            titleWeight: FontWeight.w600,
                            buttonColor: colors.ratingPremiumTags_goldAccent,
                            titleColor: colors.bACKGROUND_darkPage,
                            onTap: () async {
                              if (formKey.validateAndSave()) {
                                final pass = entity['password']?.toString() ?? '';
                                final result = await ckAuth.updatePassword(
                                  body: {'password': pass},
                                );
                                if (result.isSuccess) {
                                  CkSnackBar('Password reset successful!', type: CkSnackBarType.success);
                                  appRouter.replaceAll([const LoginRoute()]);
                                } else {
                                  CkSnackBar(result.message ?? 'Reset failed', type: CkSnackBarType.error);
                                }
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
