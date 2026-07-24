/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 12:29:06
 * @Email: km.muzahid@gmail.com
 */
import 'package:auto_route/auto_route.dart';
import 'package:cubit_template/config/route/app_router.gr.dart';

final appRouter = AppRouter();

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    /**
     * if(language is not slected then onboard){
     *   appRouter.replace(OnboardingRoute());
     *   return;
     * }
     * 
     * if(is not login){
     *   appRouter.replace(SignInOptionRoute());
     *   return;
     * }
     * 
     * if(login){
     *   appRouter.replace(HomeRoute());
     *   resolver.next();
     * return;
     * }
     */

    resolver.next();
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();
  @override
  List<AutoRouteGuard> get guards => [AuthGuard()];

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page),
  ];
}
