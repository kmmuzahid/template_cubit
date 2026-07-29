import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/config/color/app_color.dart';
import 'package:cubit_template/config/core_kit/core_kit_config.dart';
import 'package:cubit_template/features/common/widgets/app_screen_layout.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppScreenLayout(
      appBar: CkAppBar(
        title: 'Workspace',
        disableBack: true,
        hideBack: true,
        appbarConfig: CkAppBarConfig(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CkButton(
                titleText: 'Logout',
                buttonRadius: 20.w,
                buttonColor: colors.sTATUS_error.withValues(alpha: 0.15),
                titleColor: colors.sTATUS_error,
                titleSize: 12,
                titleWeight: FontWeight.w600,
                onTap: () {
                  ckAuth.logout();
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          20.height,
          // Welcome Header Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.bACKGROUND_darkCard, colors.pRIMARY_brandClr],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.w),
              border: Border.all(
                color: colors.bACKGROUND_darkCardBoarder,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 40.w,
                      color: colors.ratingPremiumTags_goldAccent,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CkText(
                            text: 'Welcome back,',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            textColor: colors.tEXT_subDark,
                            textAlign: TextAlign.left,
                          ),
                          4.height,
                          CkText(
                            text: ckAuth.profile != null
                                ? 'Active Session'
                                : 'Guest User',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            textColor: colors.tEXT_white,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.height,
                Divider(color: colors.bACKGROUND_darkCardBoarder, height: 1),
                16.height,
                CkText(
                  text: 'Profile Information:',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: colors.ratingPremiumTags_goldAccent,
                  textAlign: TextAlign.left,
                ),
                8.height,
                CkText(
                  text: '${ckAuth.profile}',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: colors.tEXT_subDark,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          20.height,
          // Quick actions header
          CkText(
            text: 'Quick Actions',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: colors.tEXT_white,
            textAlign: TextAlign.left,
          ),
          12.height,
          // Grid-like cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  subtitle: 'View analytics',
                ),
                _buildActionCard(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Preferences',
                ),
                _buildActionCard(
                  context,
                  icon: Icons.notifications_none_outlined,
                  title: 'Alerts',
                  subtitle: 'Notifications',
                ),
                _buildActionCard(
                  context,
                  icon: Icons.shield_outlined,
                  title: 'Security',
                  subtitle: 'Manage keys',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.bACKGROUND_darkCard,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: colors.bACKGROUND_darkCardBoarder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.ratingPremiumTags_goldAccent, size: 28.w),
          12.height,
          CkText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: colors.tEXT_white,
            textAlign: TextAlign.left,
          ),
          4.height,
          CkText(
            text: subtitle,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            textColor: colors.tEXT_subDark,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
