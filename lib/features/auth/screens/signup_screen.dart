import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/config/route/app_router.dart';
import 'package:cubit_template/corekit_config_impl.dart';
import 'package:cubit_template/features/auth/entity/signup_entity.dart';
import 'package:cubit_template/features/common/widgets/app_screen_layout.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScreenLayout(
      appBar: const CkAppBar(title: 'Create Account'),
      body: SingleChildScrollView(
        child: CkFormBuilder(
          entity: SignUpEntity(),
          builder: (_, formKey, entity) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                10.height,
                // Greeting header
                CkText(
                  text: 'Join Us Today',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  textColor: colors.tEXT_white,
                  textAlign: TextAlign.left,
                ),
                8.height,
                CkText(
                  text:
                      'Create a new account using our production-ready CoreKit modules.',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: colors.tEXT_subDark,
                  textAlign: TextAlign.left,
                  isDescription: true,
                ),
                20.height,

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
                        hintText: 'Choose a username',
                        validationType: CkValidationType.validateUsername,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: colors.tEXT_subDark,
                          size: 20.w,
                        ),
                        onSaved: (value, controller) => entity.username = value,
                      ),
                      16.height,

                      // Email Field
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
                        onSaved: (value, controller) => entity.email = value,
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
                        hintText: 'Create a password',
                        validationType: CkValidationType.validatePassword,
                        onChanged: (value) => entity.password = value,
                      ),
                      16.height,
                      // Password Field
                      CkText(
                        text: 'Confirm Password',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkTextField(
                        hintText: 'Confirm Password',
                        validationType:
                            CkValidationType.validateConfirmPassword,
                        originalPassword: () => entity.password ?? "",
                      ),
                      16.height,

                      // Phone Number Field (CoreKit Custom Widget)
                      CkText(
                        text: 'Phone Number',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkPhoneNumberTextField(
                        textInputAction: TextInputAction.next,
                        borderColor: colors.bACKGROUND_darkCardBoarder,
                        initalCountryCode: 'US',
                        countryChange: (phone) {
                          entity.phoneNumber = phone.completeNumber;
                        },
                        onChanged: (phone) {
                          entity.phoneNumber = phone.completeNumber;
                        },
                      ),
                      16.height,

                      // Date of Birth Field (CoreKit DatePicker Input)
                      CkText(
                        text: 'Date of Birth',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.tEXT_white,
                        textAlign: TextAlign.left,
                      ),
                      8.height,
                      CkDateInputTextField(
                        hints: 'Select your birthday',
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: colors.tEXT_subDark,
                          size: 18.w,
                        ),
                        onChanged: (date) {
                          entity.dateOfBirth = date;
                        },
                      ),
                      24.height,

                      // Signup Button
                      ckAuth.loadingUi(
                        type: CkAuthLoadingType.signUp,
                        builder: (isLoading) {
                          return CkButton(
                            titleText: 'Register',
                            isLoading: isLoading,
                            buttonRadius: 30.w,
                            titleWeight: FontWeight.w600,
                            buttonColor: colors.ratingPremiumTags_goldAccent,
                            titleColor: colors.bACKGROUND_darkPage,
                            onTap: () {
                              if (formKey.validateAndSave()) {
                                ckAuth.signUp(
                                  body: {
                                    'username': entity.username ?? '',
                                    'email': entity.email ?? '',
                                    'password': entity.password ?? '',
                                    'phone': entity.phoneNumber ?? '',
                                    'dateOfBirth':
                                        entity.dateOfBirth?.toIso8601String() ??
                                        '',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CkText(
                            text: 'Already have an account?',
                            fontSize: 13,
                            textColor: colors.tEXT_subDark,
                          ),
                          4.width,
                          GestureDetector(
                            onTap: () {
                              appRouter.pop();
                            },
                            child: CkText(
                              text: 'Sign In',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              textColor: colors.ratingPremiumTags_goldAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                30.height,
              ],
            );
          },
        ),
      ),
    );
  }
}
