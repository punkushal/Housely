import 'package:auto_route/auto_route.dart';
import 'package:housely/app/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: LocationRoute.page),
  ];
}
