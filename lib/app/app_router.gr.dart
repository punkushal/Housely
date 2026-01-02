// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:housely/features/auth/presentation/pages/forgot_password_page.dart'
    as _i5;
import 'package:housely/features/auth/presentation/pages/login_page.dart'
    as _i9;
import 'package:housely/features/auth/presentation/pages/signup_page.dart'
    as _i13;
import 'package:housely/features/detail/presentation/pages/detail_page.dart'
    as _i3;
import 'package:housely/features/home/presentation/pages/booking_page.dart'
    as _i1;
import 'package:housely/features/home/presentation/pages/explore_page.dart'
    as _i4;
import 'package:housely/features/home/presentation/pages/home_page.dart' as _i6;
import 'package:housely/features/home/presentation/pages/profile_page.dart'
    as _i11;
import 'package:housely/features/home/presentation/pages/see_all_list_page.dart'
    as _i12;
import 'package:housely/features/location/presentation/pages/location_page.dart'
    as _i7;
import 'package:housely/features/location/presentation/pages/map_picker_page.dart'
    as _i8;
import 'package:housely/features/onboarding/presentation/pages/onboarding_page.dart'
    as _i10;
import 'package:housely/features/onboarding/presentation/pages/splash_page.dart'
    as _i14;
import 'package:housely/features/property/presentation/pages/create_new_property_page.dart'
    as _i2;

/// generated route for
/// [_i1.BookingPage]
class BookingRoute extends _i15.PageRouteInfo<void> {
  const BookingRoute({List<_i15.PageRouteInfo>? children})
    : super(BookingRoute.name, initialChildren: children);

  static const String name = 'BookingRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i1.BookingPage();
    },
  );
}

/// generated route for
/// [_i2.CreateNewPropertyPage]
class CreateNewPropertyRoute extends _i15.PageRouteInfo<void> {
  const CreateNewPropertyRoute({List<_i15.PageRouteInfo>? children})
    : super(CreateNewPropertyRoute.name, initialChildren: children);

  static const String name = 'CreateNewPropertyRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateNewPropertyPage();
    },
  );
}

/// generated route for
/// [_i3.DetailPage]
class DetailRoute extends _i15.PageRouteInfo<void> {
  const DetailRoute({List<_i15.PageRouteInfo>? children})
    : super(DetailRoute.name, initialChildren: children);

  static const String name = 'DetailRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i3.DetailPage();
    },
  );
}

/// generated route for
/// [_i4.ExplorePage]
class ExploreRoute extends _i15.PageRouteInfo<void> {
  const ExploreRoute({List<_i15.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i4.ExplorePage();
    },
  );
}

/// generated route for
/// [_i5.ForgotPasswordPage]
class ForgotPasswordRoute extends _i15.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i15.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i5.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i15.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i16.Key? key,
    String? address,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i6.HomePage(key: args.key, address: args.address);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.address});

  final _i16.Key? key;

  final String? address;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, address: $address}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeRouteArgs) return false;
    return key == other.key && address == other.address;
  }

  @override
  int get hashCode => key.hashCode ^ address.hashCode;
}

/// generated route for
/// [_i7.LocationPage]
class LocationRoute extends _i15.PageRouteInfo<void> {
  const LocationRoute({List<_i15.PageRouteInfo>? children})
    : super(LocationRoute.name, initialChildren: children);

  static const String name = 'LocationRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i7.LocationPage();
    },
  );
}

/// generated route for
/// [_i8.LocationWrapper]
class LocationWrapper extends _i15.PageRouteInfo<void> {
  const LocationWrapper({List<_i15.PageRouteInfo>? children})
    : super(LocationWrapper.name, initialChildren: children);

  static const String name = 'LocationWrapper';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i8.LocationWrapper();
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i9.LoginPage();
    },
  );
}

/// generated route for
/// [_i10.OnboardingPage]
class OnboardingRoute extends _i15.PageRouteInfo<void> {
  const OnboardingRoute({List<_i15.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i10.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i11.ProfilePage]
class ProfileRoute extends _i15.PageRouteInfo<void> {
  const ProfileRoute({List<_i15.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProfilePage();
    },
  );
}

/// generated route for
/// [_i12.SeeAllListPage]
class SeeAllListRoute extends _i15.PageRouteInfo<SeeAllListRouteArgs> {
  SeeAllListRoute({
    _i16.Key? key,
    required String appBarTitle,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         SeeAllListRoute.name,
         args: SeeAllListRouteArgs(key: key, appBarTitle: appBarTitle),
         initialChildren: children,
       );

  static const String name = 'SeeAllListRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeeAllListRouteArgs>();
      return _i12.SeeAllListPage(key: args.key, appBarTitle: args.appBarTitle);
    },
  );
}

class SeeAllListRouteArgs {
  const SeeAllListRouteArgs({this.key, required this.appBarTitle});

  final _i16.Key? key;

  final String appBarTitle;

  @override
  String toString() {
    return 'SeeAllListRouteArgs{key: $key, appBarTitle: $appBarTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SeeAllListRouteArgs) return false;
    return key == other.key && appBarTitle == other.appBarTitle;
  }

  @override
  int get hashCode => key.hashCode ^ appBarTitle.hashCode;
}

/// generated route for
/// [_i13.SignupPage]
class SignupRoute extends _i15.PageRouteInfo<void> {
  const SignupRoute({List<_i15.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.SignupPage();
    },
  );
}

/// generated route for
/// [_i14.SplashPage]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i14.SplashPage();
    },
  );
}

/// generated route for
/// [_i6.TabWrapper]
class TabWrapper extends _i15.PageRouteInfo<TabWrapperArgs> {
  TabWrapper({
    _i16.Key? key,
    String? address,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         TabWrapper.name,
         args: TabWrapperArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'TabWrapper';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TabWrapperArgs>(
        orElse: () => const TabWrapperArgs(),
      );
      return _i6.TabWrapper(key: args.key, address: args.address);
    },
  );
}

class TabWrapperArgs {
  const TabWrapperArgs({this.key, this.address});

  final _i16.Key? key;

  final String? address;

  @override
  String toString() {
    return 'TabWrapperArgs{key: $key, address: $address}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TabWrapperArgs) return false;
    return key == other.key && address == other.address;
  }

  @override
  int get hashCode => key.hashCode ^ address.hashCode;
}
