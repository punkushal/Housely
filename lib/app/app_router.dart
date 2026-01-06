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
    AutoRoute(page: MapPickerRoute.page),
    AutoRoute(page: LocationRoute.page),
    AutoRoute(
      page: TabWrapper.page,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: ExploreRoute.page),
        AutoRoute(page: BookingRoute.page),
      ],
    ),
    AutoRoute(page: CreateNewPropertyRoute.page),
    AutoRoute(page: CompleteOwnerProfileRoute.page),
    AutoRoute(page: SeeAllListRoute.page),
    AutoRoute(page: DetailRoute.page),
  ];
}
