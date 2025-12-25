// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:housely/features/auth/presentation/pages/forgot_password_page.dart'
    as _i1;
import 'package:housely/features/auth/presentation/pages/login_page.dart'
    as _i3;
import 'package:housely/features/auth/presentation/pages/signup_page.dart'
    as _i6;
import 'package:housely/features/location/presentation/cubit/location_cubit.dart'
    as _i10;
import 'package:housely/features/location/presentation/pages/location_page.dart'
    as _i2;
import 'package:housely/features/location/presentation/pages/map_picker_page.dart'
    as _i4;
import 'package:housely/features/onboarding/presentation/pages/onboarding_page.dart'
    as _i5;
import 'package:housely/features/onboarding/presentation/pages/splash_page.dart'
    as _i7;

/// generated route for
/// [_i1.ForgotPasswordPage]
class ForgotPasswordRoute extends _i8.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i8.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i2.LocationWrapper]
class LocationWrapper extends _i8.PageRouteInfo<void> {
  const LocationWrapper({List<_i8.PageRouteInfo>? children})
    : super(LocationWrapper.name, initialChildren: children);

  static const String name = 'LocationWrapper';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.LocationWrapper();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginPage();
    },
  );
}

/// generated route for
/// [_i4.MapPickerPage]
class MapPickerRoute extends _i8.PageRouteInfo<MapPickerRouteArgs> {
  MapPickerRoute({
    _i9.Key? key,
    required _i10.LocationCubit locationCubit,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         MapPickerRoute.name,
         args: MapPickerRouteArgs(key: key, locationCubit: locationCubit),
         initialChildren: children,
       );

  static const String name = 'MapPickerRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapPickerRouteArgs>();
      return _i4.MapPickerPage(
        key: args.key,
        locationCubit: args.locationCubit,
      );
    },
  );
}

class MapPickerRouteArgs {
  const MapPickerRouteArgs({this.key, required this.locationCubit});

  final _i9.Key? key;

  final _i10.LocationCubit locationCubit;

  @override
  String toString() {
    return 'MapPickerRouteArgs{key: $key, locationCubit: $locationCubit}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapPickerRouteArgs) return false;
    return key == other.key && locationCubit == other.locationCubit;
  }

  @override
  int get hashCode => key.hashCode ^ locationCubit.hashCode;
}

/// generated route for
/// [_i5.OnboardingPage]
class OnboardingRoute extends _i8.PageRouteInfo<void> {
  const OnboardingRoute({List<_i8.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i6.SignupPage]
class SignupRoute extends _i8.PageRouteInfo<void> {
  const SignupRoute({List<_i8.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignupPage();
    },
  );
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashPage();
    },
  );
}
