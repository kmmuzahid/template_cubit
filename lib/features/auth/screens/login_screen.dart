import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:cubit_template/features/auth/entity/auth_entity.dart';
import 'package:cubit_template/features/common/widgets/app_screen_layout.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScreenLayout(
      appBar: const CkAppBar(
        title: 'Sign In',
        hideBack: true,
      ),
      body: SingleChildScrollView(
        child: CkFormBuilder(
          entity: AuthEntity(),
          builder: (_, formKey, entity) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.height,
                // Greeting header
                CkText(
                  text: 'Welcome Back',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  textColor: colors.tEXT_white,
                  textAlign: TextAlign.left,
                ),
                8.height,
                CkText(
                  text: 'Enter your credentials to access your workspace',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: colors.tEXT_subDark,
                  textAlign: TextAlign.left,
                ),
                30.height,

                // Content Card
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
                      // Username Field
                      CkText(
                        text: 'Username',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkTextField(
                        hintText: 'Enter your username',
                        validationType: CkValidationType.validateUsername,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        onSaved: (value, controller) => entity.username = value,
                      ),
                      16.height,

                      // Password Field
                      CkText(
                        text: 'Password',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkTextField(
                        hintText: 'Enter your password',
                        validationType: CkValidationType.validatePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        onChanged: (value) => entity.password = value,
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
                        hintText: 'Re-enter your password',
                        validationType: CkValidationType.validateConfirmPassword,
                        prefixIcon: Icon(
                          Icons.lock_reset,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        originalPassword: () => entity.password ?? '',
                      ),
                      24.height,

                      // Login Button
                      ckAuth.loadingUi(
                        type: CkAuthLoadingType.signIn,
                        builder: (isLoading) {
                          return CkButton(
                            titleText: 'Sign In',
                            isLoading: isLoading,
                            buttonRadius: 30.w,
                            titleWeight: FontWeight.w600,
                            buttonColor: colors.ratingPremiumTags_goldAccent,
                            titleColor: colors.bACKGROUND_darkPage,
                            onTap: () {
                              ckAuth.signIn(
                                username: entity.username ?? '',
                                password: entity.password ?? '',
                              );
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

