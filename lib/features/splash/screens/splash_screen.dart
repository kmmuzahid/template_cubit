import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/features/auth/widgets/app_screen_layout.dart';
import 'package:cubit_template/features/splash/cubit/live_counter_graft.dart';
import 'package:cubit_template/features/splash/cubit/splash_cubit.dart';
import 'package:graft/graft.dart';
import 'package:material_ui/material_ui.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final graft = context.create<SplashCubit>()..init();
    final counterGraft = context.use<LiveCounterGraft>();

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
            Container(color: Colors.red, child: Text(state.name)),
            // App Name
            CkText(
              text: state.name,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Name: ${state.name}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            16.height,
            Container(
              color: Colors.lightBlueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Timer: ${state.time}s',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            30.height,
            // Nested independent Graft testing cross-graft isolation
            Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: counterGraft.slots(
                (children) =>
                    Row(mainAxisSize: MainAxisSize.min, children: children),
                (counterState) => [
                  Text(
                    'Counter: ${counterState.count}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: counterGraft.increment,
                    child: const Text('+1'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
