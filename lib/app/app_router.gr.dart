// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:housely/features/auth/presentation/pages/login_page.dart'
    as _i1;
import 'package:housely/features/onboarding/presentation/pages/onboarding_page.dart'
    as _i2;
import 'package:housely/features/onboarding/presentation/pages/splash_page.dart'
    as _i3;

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute({List<_i4.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginPage();
    },
  );
}

/// generated route for
/// [_i2.OnboardingPage]
class OnboardingRoute extends _i4.PageRouteInfo<void> {
  const OnboardingRoute({List<_i4.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i3.SplashPage]
class SplashRoute extends _i4.PageRouteInfo<void> {
  const SplashRoute({List<_i4.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashPage();
    },
  );
}
