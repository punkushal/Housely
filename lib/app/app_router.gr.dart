// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:housely/features/auth/presentation/pages/forgot_password_page.dart'
    as _i6;
import 'package:housely/features/auth/presentation/pages/login_page.dart'
    as _i9;
import 'package:housely/features/auth/presentation/pages/signup_page.dart'
    as _i15;
import 'package:housely/features/detail/presentation/pages/detail_page.dart'
    as _i4;
import 'package:housely/features/home/presentation/pages/booking_page.dart'
    as _i1;
import 'package:housely/features/home/presentation/pages/explore_page.dart'
    as _i5;
import 'package:housely/features/home/presentation/pages/home_page.dart' as _i7;
import 'package:housely/features/home/presentation/pages/profile_page.dart'
    as _i13;
import 'package:housely/features/home/presentation/pages/see_all_list_page.dart'
    as _i14;
import 'package:housely/features/location/domain/entities/location.dart'
    as _i20;
import 'package:housely/features/location/presentation/pages/location_page.dart'
    as _i8;
import 'package:housely/features/location/presentation/pages/map_picker_page.dart'
    as _i10;
import 'package:housely/features/onboarding/presentation/pages/onboarding_page.dart'
    as _i12;
import 'package:housely/features/onboarding/presentation/pages/splash_page.dart'
    as _i16;
import 'package:housely/features/property/domain/entities/property.dart'
    as _i19;
import 'package:housely/features/property/presentation/pages/complete_owner_profile_page.dart'
    as _i2;
import 'package:housely/features/property/presentation/pages/create_new_property_page.dart'
    as _i3;
import 'package:housely/features/property/presentation/pages/my_property_list_page.dart'
    as _i11;

/// generated route for
/// [_i1.BookingPage]
class BookingRoute extends _i17.PageRouteInfo<void> {
  const BookingRoute({List<_i17.PageRouteInfo>? children})
    : super(BookingRoute.name, initialChildren: children);

  static const String name = 'BookingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.BookingPage();
    },
  );
}

/// generated route for
/// [_i2.CompleteOwnerProfilePage]
class CompleteOwnerProfileRoute extends _i17.PageRouteInfo<void> {
  const CompleteOwnerProfileRoute({List<_i17.PageRouteInfo>? children})
    : super(CompleteOwnerProfileRoute.name, initialChildren: children);

  static const String name = 'CompleteOwnerProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.CompleteOwnerProfilePage();
    },
  );
}

/// generated route for
/// [_i3.CreateNewPropertyPage]
class CreateNewPropertyRoute
    extends _i17.PageRouteInfo<CreateNewPropertyRouteArgs> {
  CreateNewPropertyRoute({
    _i18.Key? key,
    _i19.Property? property,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         CreateNewPropertyRoute.name,
         args: CreateNewPropertyRouteArgs(key: key, property: property),
         initialChildren: children,
       );

  static const String name = 'CreateNewPropertyRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewPropertyRouteArgs>(
        orElse: () => const CreateNewPropertyRouteArgs(),
      );
      return _i17.WrappedRoute(
        child: _i3.CreateNewPropertyPage(
          key: args.key,
          property: args.property,
        ),
      );
    },
  );
}

class CreateNewPropertyRouteArgs {
  const CreateNewPropertyRouteArgs({this.key, this.property});

  final _i18.Key? key;

  final _i19.Property? property;

  @override
  String toString() {
    return 'CreateNewPropertyRouteArgs{key: $key, property: $property}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateNewPropertyRouteArgs) return false;
    return key == other.key && property == other.property;
  }

  @override
  int get hashCode => key.hashCode ^ property.hashCode;
}

/// generated route for
/// [_i4.DetailPage]
class DetailRoute extends _i17.PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    _i18.Key? key,
    required _i19.Property property,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         DetailRoute.name,
         args: DetailRouteArgs(key: key, property: property),
         initialChildren: children,
       );

  static const String name = 'DetailRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailRouteArgs>();
      return _i4.DetailPage(key: args.key, property: args.property);
    },
  );
}

class DetailRouteArgs {
  const DetailRouteArgs({this.key, required this.property});

  final _i18.Key? key;

  final _i19.Property property;

  @override
  String toString() {
    return 'DetailRouteArgs{key: $key, property: $property}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailRouteArgs) return false;
    return key == other.key && property == other.property;
  }

  @override
  int get hashCode => key.hashCode ^ property.hashCode;
}

/// generated route for
/// [_i5.ExplorePage]
class ExploreRoute extends _i17.PageRouteInfo<void> {
  const ExploreRoute({List<_i17.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.ExplorePage();
    },
  );
}

/// generated route for
/// [_i6.ForgotPasswordPage]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i17.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i18.Key? key,
    String? address,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i7.HomePage(key: args.key, address: args.address);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.address});

  final _i18.Key? key;

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
/// [_i8.LocationPage]
class LocationRoute extends _i17.PageRouteInfo<void> {
  const LocationRoute({List<_i17.PageRouteInfo>? children})
    : super(LocationRoute.name, initialChildren: children);

  static const String name = 'LocationRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.LocationPage();
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.LoginPage();
    },
  );
}

/// generated route for
/// [_i10.MapPickerPage]
class MapPickerRoute extends _i17.PageRouteInfo<MapPickerRouteArgs> {
  MapPickerRoute({
    _i18.Key? key,
    bool isOwner = false,
    _i20.Location? initialLocation,
    bool isVisitor = false,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         MapPickerRoute.name,
         args: MapPickerRouteArgs(
           key: key,
           isOwner: isOwner,
           initialLocation: initialLocation,
           isVisitor: isVisitor,
         ),
         initialChildren: children,
       );

  static const String name = 'MapPickerRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapPickerRouteArgs>(
        orElse: () => const MapPickerRouteArgs(),
      );
      return _i17.WrappedRoute(
        child: _i10.MapPickerPage(
          key: args.key,
          isOwner: args.isOwner,
          initialLocation: args.initialLocation,
          isVisitor: args.isVisitor,
        ),
      );
    },
  );
}

class MapPickerRouteArgs {
  const MapPickerRouteArgs({
    this.key,
    this.isOwner = false,
    this.initialLocation,
    this.isVisitor = false,
  });

  final _i18.Key? key;

  final bool isOwner;

  final _i20.Location? initialLocation;

  final bool isVisitor;

  @override
  String toString() {
    return 'MapPickerRouteArgs{key: $key, isOwner: $isOwner, initialLocation: $initialLocation, isVisitor: $isVisitor}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapPickerRouteArgs) return false;
    return key == other.key &&
        isOwner == other.isOwner &&
        initialLocation == other.initialLocation &&
        isVisitor == other.isVisitor;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      isOwner.hashCode ^
      initialLocation.hashCode ^
      isVisitor.hashCode;
}

/// generated route for
/// [_i11.MyPropertyListPage]
class MyPropertyListRoute extends _i17.PageRouteInfo<void> {
  const MyPropertyListRoute({List<_i17.PageRouteInfo>? children})
    : super(MyPropertyListRoute.name, initialChildren: children);

  static const String name = 'MyPropertyListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.MyPropertyListPage();
    },
  );
}

/// generated route for
/// [_i12.OnboardingPage]
class OnboardingRoute extends _i17.PageRouteInfo<void> {
  const OnboardingRoute({List<_i17.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i13.ProfilePage]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfilePage();
    },
  );
}

/// generated route for
/// [_i14.SeeAllListPage]
class SeeAllListRoute extends _i17.PageRouteInfo<SeeAllListRouteArgs> {
  SeeAllListRoute({
    _i18.Key? key,
    required String appBarTitle,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         SeeAllListRoute.name,
         args: SeeAllListRouteArgs(key: key, appBarTitle: appBarTitle),
         initialChildren: children,
       );

  static const String name = 'SeeAllListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeeAllListRouteArgs>();
      return _i14.SeeAllListPage(key: args.key, appBarTitle: args.appBarTitle);
    },
  );
}

class SeeAllListRouteArgs {
  const SeeAllListRouteArgs({this.key, required this.appBarTitle});

  final _i18.Key? key;

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
/// [_i15.SignupPage]
class SignupRoute extends _i17.PageRouteInfo<void> {
  const SignupRoute({List<_i17.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.SignupPage();
    },
  );
}

/// generated route for
/// [_i16.SplashPage]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.SplashPage();
    },
  );
}

/// generated route for
/// [_i7.TabWrapper]
class TabWrapper extends _i17.PageRouteInfo<TabWrapperArgs> {
  TabWrapper({
    _i18.Key? key,
    String? address,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         TabWrapper.name,
         args: TabWrapperArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'TabWrapper';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TabWrapperArgs>(
        orElse: () => const TabWrapperArgs(),
      );
      return _i7.TabWrapper(key: args.key, address: args.address);
    },
  );
}

class TabWrapperArgs {
  const TabWrapperArgs({this.key, this.address});

  final _i18.Key? key;

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
