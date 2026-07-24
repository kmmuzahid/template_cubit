import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/bloc/cubit_scope.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/features/common/widgets/app_screen_layout.dart';
import 'package:cubit_template/features/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScreenLayout(
      useSafeArea: false,
      padding: EdgeInsets.zero,
      body: CubitScope(
        create: () => SplashCubit()..init(),
        builder: (context, cubit, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stylized premium brand logo
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: colors.bACKGROUND_darkCard,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.ratingPremiumTags_goldAccent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.ratingPremiumTags_goldAccent.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 60.w,
                    color: colors.ratingPremiumTags_goldAccent,
                  ),
                ),
                40.height,
                // App Name
                CkText(
                  text: 'COREKIT EXAMPLE',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  textColor: colors.tEXT_white,
                  gradient: LinearGradient(
                    colors: [
                      colors.tEXT_white,
                      colors.ratingPremiumTags_goldAccent,
                    ],
                  ),
                ),
                8.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: CkText(
                    text:
                        'A Flutter package bundling production-ready UI widgets, responsive layout helpers, Dio-based networking, secure storage, and authentication.',
                    fontSize: 13,
                    isDescription: true,
                    fontWeight: FontWeight.w400,
                    textColor: colors.tEXT_subDark,
                  ),
                ),
                60.height,
                if (state)
                  SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: CircularProgressIndicator(
                      color: colors.ratingPremiumTags_goldAccent,
                      strokeWidth: 2.5,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
