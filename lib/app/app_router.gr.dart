// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:collection/collection.dart' as _i31;
import 'package:flutter/material.dart' as _i28;
import 'package:housely/features/auth/domain/entities/app_user.dart' as _i33;
import 'package:housely/features/auth/presentation/pages/forgot_password_page.dart'
    as _i13;
import 'package:housely/features/auth/presentation/pages/login_page.dart'
    as _i16;
import 'package:housely/features/auth/presentation/pages/signup_page.dart'
    as _i25;
import 'package:housely/features/booking/presentation/page/booking_page.dart'
    as _i3;
import 'package:housely/features/booking/presentation/page/booking_request_page.dart'
    as _i4;
import 'package:housely/features/booking/presentation/page/my_booking_page.dart'
    as _i18;
import 'package:housely/features/chat/domain/entity/chat_user.dart' as _i32;
import 'package:housely/features/chat/presentation/page/chat_list_page.dart'
    as _i5;
import 'package:housely/features/chat/presentation/page/chat_page.dart' as _i6;
import 'package:housely/features/detail/presentation/pages/detail_page.dart'
    as _i9;
import 'package:housely/features/favorites/presentation/page/favorite_page.dart'
    as _i12;
import 'package:housely/features/home/presentation/pages/home_page.dart'
    as _i14;
import 'package:housely/features/home/presentation/pages/see_all_list_page.dart'
    as _i24;
import 'package:housely/features/location/domain/entities/location.dart'
    as _i36;
import 'package:housely/features/location/presentation/pages/location_page.dart'
    as _i15;
import 'package:housely/features/location/presentation/pages/map_picker_page.dart'
    as _i17;
import 'package:housely/features/onboarding/presentation/pages/onboarding_page.dart'
    as _i20;
import 'package:housely/features/onboarding/presentation/pages/splash_page.dart'
    as _i26;
import 'package:housely/features/profile/presentation/cubit/profile_cubit.dart'
    as _i34;
import 'package:housely/features/profile/presentation/pages/edit_profile_page.dart'
    as _i10;
import 'package:housely/features/profile/presentation/pages/payment_history_page.dart'
    as _i21;
import 'package:housely/features/profile/presentation/pages/profile_page.dart'
    as _i22;
import 'package:housely/features/property/domain/entities/property.dart'
    as _i29;
import 'package:housely/features/property/domain/entities/property_owner.dart'
    as _i35;
import 'package:housely/features/property/presentation/pages/complete_owner_profile_page.dart'
    as _i7;
import 'package:housely/features/property/presentation/pages/create_new_property_page.dart'
    as _i8;
import 'package:housely/features/property/presentation/pages/my_property_list_page.dart'
    as _i19;
import 'package:housely/features/review/domain/entity/review.dart' as _i30;
import 'package:housely/features/review/presentation/pages/add_review_page.dart'
    as _i1;
import 'package:housely/features/review/presentation/pages/all_review_list_page.dart'
    as _i2;
import 'package:housely/features/review/presentation/pages/review_detail_page.dart'
    as _i23;
import 'package:housely/features/search/presentation/page/explore_page.dart'
    as _i11;

/// generated route for
/// [_i1.AddReviewPage]
class AddReviewRoute extends _i27.PageRouteInfo<AddReviewRouteArgs> {
  AddReviewRoute({
    _i28.Key? key,
    required _i29.Property property,
    _i30.Review? existedReview,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         AddReviewRoute.name,
         args: AddReviewRouteArgs(
           key: key,
           property: property,
           existedReview: existedReview,
         ),
         initialChildren: children,
       );

  static const String name = 'AddReviewRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddReviewRouteArgs>();
      return _i27.WrappedRoute(
        child: _i1.AddReviewPage(
          key: args.key,
          property: args.property,
          existedReview: args.existedReview,
        ),
      );
    },
  );
}

class AddReviewRouteArgs {
  const AddReviewRouteArgs({
    this.key,
    required this.property,
    this.existedReview,
  });

  final _i28.Key? key;

  final _i29.Property property;

  final _i30.Review? existedReview;

  @override
  String toString() {
    return 'AddReviewRouteArgs{key: $key, property: $property, existedReview: $existedReview}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddReviewRouteArgs) return false;
    return key == other.key &&
        property == other.property &&
        existedReview == other.existedReview;
  }

  @override
  int get hashCode => key.hashCode ^ property.hashCode ^ existedReview.hashCode;
}

/// generated route for
/// [_i2.AllReviewListPage]
class AllReviewListRoute extends _i27.PageRouteInfo<AllReviewListRouteArgs> {
  AllReviewListRoute({
    _i28.Key? key,
    required List<_i30.Review> allReviews,
    required _i29.Property property,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         AllReviewListRoute.name,
         args: AllReviewListRouteArgs(
           key: key,
           allReviews: allReviews,
           property: property,
         ),
         initialChildren: children,
       );

  static const String name = 'AllReviewListRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllReviewListRouteArgs>();
      return _i2.AllReviewListPage(
        key: args.key,
        allReviews: args.allReviews,
        property: args.property,
      );
    },
  );
}

class AllReviewListRouteArgs {
  const AllReviewListRouteArgs({
    this.key,
    required this.allReviews,
    required this.property,
  });

  final _i28.Key? key;

  final List<_i30.Review> allReviews;

  final _i29.Property property;

  @override
  String toString() {
    return 'AllReviewListRouteArgs{key: $key, allReviews: $allReviews, property: $property}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AllReviewListRouteArgs) return false;
    return key == other.key &&
        const _i31.ListEquality<_i30.Review>().equals(
          allReviews,
          other.allReviews,
        ) &&
        property == other.property;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i31.ListEquality<_i30.Review>().hash(allReviews) ^
      property.hashCode;
}

/// generated route for
/// [_i3.BookingPage]
class BookingRoute extends _i27.PageRouteInfo<BookingRouteArgs> {
  BookingRoute({
    _i28.Key? key,
    required _i29.Property property,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         BookingRoute.name,
         args: BookingRouteArgs(key: key, property: property),
         initialChildren: children,
       );

  static const String name = 'BookingRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookingRouteArgs>();
      return _i3.BookingPage(key: args.key, property: args.property);
    },
  );
}

class BookingRouteArgs {
  const BookingRouteArgs({this.key, required this.property});

  final _i28.Key? key;

  final _i29.Property property;

  @override
  String toString() {
    return 'BookingRouteArgs{key: $key, property: $property}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookingRouteArgs) return false;
    return key == other.key && property == other.property;
  }

  @override
  int get hashCode => key.hashCode ^ property.hashCode;
}

/// generated route for
/// [_i4.BookingRequestPage]
class BookingRequestRoute extends _i27.PageRouteInfo<void> {
  const BookingRequestRoute({List<_i27.PageRouteInfo>? children})
    : super(BookingRequestRoute.name, initialChildren: children);

  static const String name = 'BookingRequestRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i4.BookingRequestPage();
    },
  );
}

/// generated route for
/// [_i5.ChatListPage]
class ChatListRoute extends _i27.PageRouteInfo<void> {
  const ChatListRoute({List<_i27.PageRouteInfo>? children})
    : super(ChatListRoute.name, initialChildren: children);

  static const String name = 'ChatListRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return _i27.WrappedRoute(child: const _i5.ChatListPage());
    },
  );
}

/// generated route for
/// [_i6.ChatPage]
class ChatRoute extends _i27.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i28.Key? key,
    required _i32.ChatUser currentUser,
    required _i32.ChatUser otherUser,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(
           key: key,
           currentUser: currentUser,
           otherUser: otherUser,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i27.WrappedRoute(
        child: _i6.ChatPage(
          key: args.key,
          currentUser: args.currentUser,
          otherUser: args.otherUser,
        ),
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.currentUser,
    required this.otherUser,
  });

  final _i28.Key? key;

  final _i32.ChatUser currentUser;

  final _i32.ChatUser otherUser;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, currentUser: $currentUser, otherUser: $otherUser}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key &&
        currentUser == other.currentUser &&
        otherUser == other.otherUser;
  }

  @override
  int get hashCode => key.hashCode ^ currentUser.hashCode ^ otherUser.hashCode;
}

/// generated route for
/// [_i7.CompleteOwnerProfilePage]
class CompleteOwnerProfileRoute extends _i27.PageRouteInfo<void> {
  const CompleteOwnerProfileRoute({List<_i27.PageRouteInfo>? children})
    : super(CompleteOwnerProfileRoute.name, initialChildren: children);

  static const String name = 'CompleteOwnerProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.CompleteOwnerProfilePage();
    },
  );
}

/// generated route for
/// [_i8.CreateNewPropertyPage]
class CreateNewPropertyRoute
    extends _i27.PageRouteInfo<CreateNewPropertyRouteArgs> {
  CreateNewPropertyRoute({
    _i28.Key? key,
    _i29.Property? property,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         CreateNewPropertyRoute.name,
         args: CreateNewPropertyRouteArgs(key: key, property: property),
         initialChildren: children,
       );

  static const String name = 'CreateNewPropertyRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewPropertyRouteArgs>(
        orElse: () => const CreateNewPropertyRouteArgs(),
      );
      return _i27.WrappedRoute(
        child: _i8.CreateNewPropertyPage(
          key: args.key,
          property: args.property,
        ),
      );
    },
  );
}

class CreateNewPropertyRouteArgs {
  const CreateNewPropertyRouteArgs({this.key, this.property});

  final _i28.Key? key;

  final _i29.Property? property;

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
/// [_i9.DetailPage]
class DetailRoute extends _i27.PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    _i28.Key? key,
    required _i29.Property property,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         DetailRoute.name,
         args: DetailRouteArgs(key: key, property: property),
         initialChildren: children,
       );

  static const String name = 'DetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailRouteArgs>();
      return _i9.DetailPage(key: args.key, property: args.property);
    },
  );
}

class DetailRouteArgs {
  const DetailRouteArgs({this.key, required this.property});

  final _i28.Key? key;

  final _i29.Property property;

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
/// [_i10.EditProfilePage]
class EditProfileRoute extends _i27.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i28.Key? key,
    required _i33.AppUser appUser,
    required _i34.ProfileCubit profileCubit,
    _i35.PropertyOwner? owner,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         EditProfileRoute.name,
         args: EditProfileRouteArgs(
           key: key,
           appUser: appUser,
           profileCubit: profileCubit,
           owner: owner,
         ),
         initialChildren: children,
       );

  static const String name = 'EditProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>();
      return _i10.EditProfilePage(
        key: args.key,
        appUser: args.appUser,
        profileCubit: args.profileCubit,
        owner: args.owner,
      );
    },
  );
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({
    this.key,
    required this.appUser,
    required this.profileCubit,
    this.owner,
  });

  final _i28.Key? key;

  final _i33.AppUser appUser;

  final _i34.ProfileCubit profileCubit;

  final _i35.PropertyOwner? owner;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, appUser: $appUser, profileCubit: $profileCubit, owner: $owner}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditProfileRouteArgs) return false;
    return key == other.key &&
        appUser == other.appUser &&
        profileCubit == other.profileCubit &&
        owner == other.owner;
  }

  @override
  int get hashCode =>
      key.hashCode ^ appUser.hashCode ^ profileCubit.hashCode ^ owner.hashCode;
}

/// generated route for
/// [_i11.ExplorePage]
class ExploreRoute extends _i27.PageRouteInfo<void> {
  const ExploreRoute({List<_i27.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return _i27.WrappedRoute(child: const _i11.ExplorePage());
    },
  );
}

/// generated route for
/// [_i12.FavoritePage]
class FavoriteRoute extends _i27.PageRouteInfo<void> {
  const FavoriteRoute({List<_i27.PageRouteInfo>? children})
    : super(FavoriteRoute.name, initialChildren: children);

  static const String name = 'FavoriteRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.FavoritePage();
    },
  );
}

/// generated route for
/// [_i13.ForgotPasswordPage]
class ForgotPasswordRoute extends _i27.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i27.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i13.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i14.HomePage]
class HomeRoute extends _i27.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i28.Key? key,
    String? address,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i14.HomePage(key: args.key, address: args.address);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.address});

  final _i28.Key? key;

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
/// [_i15.LocationPage]
class LocationRoute extends _i27.PageRouteInfo<void> {
  const LocationRoute({List<_i27.PageRouteInfo>? children})
    : super(LocationRoute.name, initialChildren: children);

  static const String name = 'LocationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.LocationPage();
    },
  );
}

/// generated route for
/// [_i16.LoginPage]
class LoginRoute extends _i27.PageRouteInfo<void> {
  const LoginRoute({List<_i27.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i16.LoginPage();
    },
  );
}

/// generated route for
/// [_i17.MapPickerPage]
class MapPickerRoute extends _i27.PageRouteInfo<MapPickerRouteArgs> {
  MapPickerRoute({
    _i28.Key? key,
    bool isOwner = false,
    _i36.Location? initialLocation,
    bool isVisitor = false,
    List<_i27.PageRouteInfo>? children,
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

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapPickerRouteArgs>(
        orElse: () => const MapPickerRouteArgs(),
      );
      return _i27.WrappedRoute(
        child: _i17.MapPickerPage(
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

  final _i28.Key? key;

  final bool isOwner;

  final _i36.Location? initialLocation;

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
/// [_i18.MyBookingPage]
class MyBookingRoute extends _i27.PageRouteInfo<void> {
  const MyBookingRoute({List<_i27.PageRouteInfo>? children})
    : super(MyBookingRoute.name, initialChildren: children);

  static const String name = 'MyBookingRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i18.MyBookingPage();
    },
  );
}

/// generated route for
/// [_i19.MyPropertyListPage]
class MyPropertyListRoute extends _i27.PageRouteInfo<void> {
  const MyPropertyListRoute({List<_i27.PageRouteInfo>? children})
    : super(MyPropertyListRoute.name, initialChildren: children);

  static const String name = 'MyPropertyListRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.MyPropertyListPage();
    },
  );
}

/// generated route for
/// [_i20.OnboardingPage]
class OnboardingRoute extends _i27.PageRouteInfo<void> {
  const OnboardingRoute({List<_i27.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i20.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i21.PaymentHistoryPage]
class PaymentHistoryRoute extends _i27.PageRouteInfo<void> {
  const PaymentHistoryRoute({List<_i27.PageRouteInfo>? children})
    : super(PaymentHistoryRoute.name, initialChildren: children);

  static const String name = 'PaymentHistoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i21.PaymentHistoryPage();
    },
  );
}

/// generated route for
/// [_i22.ProfilePage]
class ProfileRoute extends _i27.PageRouteInfo<void> {
  const ProfileRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i22.ProfilePage();
    },
  );
}

/// generated route for
/// [_i23.ReviewDetailPage]
class ReviewDetailRoute extends _i27.PageRouteInfo<ReviewDetailRouteArgs> {
  ReviewDetailRoute({
    _i28.Key? key,
    required _i30.Review review,
    required _i29.Property property,
    required int totalReviews,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         ReviewDetailRoute.name,
         args: ReviewDetailRouteArgs(
           key: key,
           review: review,
           property: property,
           totalReviews: totalReviews,
         ),
         initialChildren: children,
       );

  static const String name = 'ReviewDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReviewDetailRouteArgs>();
      return _i23.ReviewDetailPage(
        key: args.key,
        review: args.review,
        property: args.property,
        totalReviews: args.totalReviews,
      );
    },
  );
}

class ReviewDetailRouteArgs {
  const ReviewDetailRouteArgs({
    this.key,
    required this.review,
    required this.property,
    required this.totalReviews,
  });

  final _i28.Key? key;

  final _i30.Review review;

  final _i29.Property property;

  final int totalReviews;

  @override
  String toString() {
    return 'ReviewDetailRouteArgs{key: $key, review: $review, property: $property, totalReviews: $totalReviews}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReviewDetailRouteArgs) return false;
    return key == other.key &&
        review == other.review &&
        property == other.property &&
        totalReviews == other.totalReviews;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      review.hashCode ^
      property.hashCode ^
      totalReviews.hashCode;
}

/// generated route for
/// [_i24.SeeAllListPage]
class SeeAllListRoute extends _i27.PageRouteInfo<SeeAllListRouteArgs> {
  SeeAllListRoute({
    _i28.Key? key,
    required String appBarTitle,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         SeeAllListRoute.name,
         args: SeeAllListRouteArgs(key: key, appBarTitle: appBarTitle),
         initialChildren: children,
       );

  static const String name = 'SeeAllListRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeeAllListRouteArgs>();
      return _i24.SeeAllListPage(key: args.key, appBarTitle: args.appBarTitle);
    },
  );
}

class SeeAllListRouteArgs {
  const SeeAllListRouteArgs({this.key, required this.appBarTitle});

  final _i28.Key? key;

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
/// [_i25.SignupPage]
class SignupRoute extends _i27.PageRouteInfo<void> {
  const SignupRoute({List<_i27.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i25.SignupPage();
    },
  );
}

/// generated route for
/// [_i26.SplashPage]
class SplashRoute extends _i27.PageRouteInfo<void> {
  const SplashRoute({List<_i27.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.SplashPage();
    },
  );
}

/// generated route for
/// [_i14.TabWrapper]
class TabWrapper extends _i27.PageRouteInfo<TabWrapperArgs> {
  TabWrapper({
    _i28.Key? key,
    String? address,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         TabWrapper.name,
         args: TabWrapperArgs(key: key, address: address),
         initialChildren: children,
       );

  static const String name = 'TabWrapper';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TabWrapperArgs>(
        orElse: () => const TabWrapperArgs(),
      );
      return _i14.TabWrapper(key: args.key, address: args.address);
    },
  );
}

class TabWrapperArgs {
  const TabWrapperArgs({this.key, this.address});

  final _i28.Key? key;

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
