import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/features/auth/widgets/app_screen_layout.dart';
import 'package:cubit_template/features/splash/cubit/splash_cubit.dart';
import 'package:graft/graft.dart';
import 'package:material_ui/material_ui.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final graft = context.use<SplashCubit>()..init();

    return AppScreenLayout(
      useSafeArea: false,
      padding: EdgeInsets.zero,
      body: Center(
        child: graft.slots(
          (children) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
          (state) => [
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
              child: Text(
                'A Flutter package bundling production-ready UI widgets, responsive layout helpers, Dio-based networking, secure storage, and authentication.',
              ),
            ),
            60.height,
            Container(
              color: Colors.white,
              padding: .all(10),
              child: Text(state.name, style: TextStyle(color: Colors.black)),
            ),
            50.height,
            Container(
              color: state.time % 2 == 0 ? Colors.amberAccent : Colors.white,
              padding: .all(10),
              child: Text(
                state.time.toString(),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
