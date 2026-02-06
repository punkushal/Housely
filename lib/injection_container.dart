import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app_router.dart';
import 'core/constants/text_constants.dart';
import 'core/database/app_database.dart';
import 'core/network/cubit/connectivity_cubit.dart';
import 'env/env.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/usecases/auth_state_change_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_use_case.dart';
import 'features/auth/domain/usecases/google_signin_usecase.dart';
import 'features/auth/domain/usecases/login_status_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/google_signin_cubit.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/cubit/logout_cubit.dart';
import 'features/auth/presentation/cubit/password_reset_cubit.dart';
import 'features/auth/presentation/cubit/register_cubit.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/data/datasources/esewa_remote_data_source.dart';
import 'features/booking/data/repository/booking_repo_impl.dart';
import 'features/booking/data/repository/esewa_payment_repo_impl.dart';
import 'features/booking/domain/repository/booking_repo.dart';
import 'features/booking/domain/repository/esewa_payment_repo.dart';
import 'features/booking/domain/usecases/get_booking_request_list_use_case.dart';
import 'features/booking/domain/usecases/get_property_bookings_use_case.dart';
import 'features/booking/domain/usecases/initiate_esewa_pay_use_case.dart';
import 'features/booking/domain/usecases/listen_booking_changes_use_case.dart';
import 'features/booking/domain/usecases/request_booking_use_case.dart';
import 'features/booking/domain/usecases/respond_booking_use_case.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/booking/presentation/bloc/payment_bloc.dart';
import 'features/booking/presentation/cubit/calendar_cubit.dart';
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repository/chat_repo_impl.dart';
import 'features/chat/domain/repositories/chat_repo.dart';
import 'features/chat/domain/usecases/create_or_get_chat.dart';
import 'features/chat/domain/usecases/delete_chat_use_case.dart';
import 'features/chat/domain/usecases/delete_message.dart'
    as delete_message_usecase;
import 'features/chat/domain/usecases/get_chat_list.dart';
import 'features/chat/domain/usecases/get_messages_use_case.dart';
import 'features/chat/domain/usecases/get_user_status.dart';
import 'features/chat/domain/usecases/mark_message_as_read.dart'
    as mark_message;
import 'features/chat/domain/usecases/send_message_use_case.dart';
import 'features/chat/domain/usecases/send_push_notification_use_case.dart';
import 'features/chat/domain/usecases/update_user_status.dart';
import 'features/chat/presentation/bloc/chat_list_bloc.dart';
import 'features/chat/presentation/bloc/chat_session_bloc.dart';
import 'features/favorites/data/datasources/favorite_local_data_source.dart';
import 'features/favorites/data/repository/favorite_repository_impl.dart';
import 'features/favorites/domain/repository/favorite_repository.dart';
import 'features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'features/favorites/domain/usecases/is_favorite_use_case.dart';
import 'features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/location/data/datasources/location_local_data_source.dart';
import 'features/location/data/repositories/location_repo_impl.dart';
import 'features/location/domain/repositories/location_repo.dart';
import 'features/location/domain/usecases/check_location_permission_use_case.dart';
import 'features/location/domain/usecases/check_service_enabled_use_case.dart';
import 'features/location/domain/usecases/get_current_location_use_case.dart';
import 'features/location/domain/usecases/request_location_permission_use_case.dart';
import 'features/location/presentation/cubit/location_cubit.dart';
import 'features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repo_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'features/onboarding/domain/usecases/set_onboarding_status_usecase.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/profile/data/datasources/payment_history_remote_data_source.dart';
import 'features/profile/data/repository/payment_history_repo_impl.dart';
import 'features/profile/domain/repository/payment_history_repo.dart';
import 'features/profile/domain/usecases/delete_profile_image_use_case.dart';
import 'features/profile/domain/usecases/get_payment_history_use_case.dart';
import 'features/profile/domain/usecases/upload_profile_image_use_case.dart';
import 'features/profile/presentation/cubit/payments/cubit/payment_history_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'package:housely/features/notification/presentation/cubit/notification_cubit.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repository/profile_repo_impl.dart';
import 'features/profile/domain/repository/profile_repo.dart';
import 'features/profile/domain/usecases/update_user_profile_use_case.dart';
import 'features/property/data/datasources/app_write_data_source.dart';
import 'features/property/data/datasources/property_remote_data_source.dart';
import 'features/property/data/repository/owner_repo_impl.dart';
import 'features/property/data/repository/property_repo_impl.dart';
import 'features/property/domain/repository/owner_repo.dart';
import 'features/property/domain/repository/property_repo.dart';
import 'features/property/domain/usecases/create_owner_profile.dart';
import 'features/property/domain/usecases/create_property.dart';
import 'features/property/domain/usecases/delete_image_file.dart';
import 'features/property/domain/usecases/delete_property.dart';
import 'features/property/domain/usecases/fetch/get_my_properties_use_case.dart';
import 'features/property/domain/usecases/fetch/get_property_by_id_use_case.dart';
import 'features/property/domain/usecases/fetch/get_recommended_properties_use_case.dart';
import 'features/property/domain/usecases/fetch_all_properties.dart';
import 'features/property/domain/usecases/get_owner_profile.dart';
import 'features/property/domain/usecases/search_and_filter.dart';
import 'features/property/domain/usecases/update_image_file.dart';
import 'features/property/domain/usecases/update_property.dart';
import 'features/property/domain/usecases/upload_cover_image.dart';
import 'features/property/domain/usecases/upload_property_images.dart';
import 'features/property/presentation/bloc/crud/property_crud_bloc.dart';
import 'features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'features/property/presentation/cubit/owner/owner_cubit.dart';
import 'features/property/presentation/cubit/form/property_form_cubit.dart';
import 'features/review/data/datasource/review_remote_data_source.dart';
import 'features/review/data/repository/review_repo_impl.dart';
import 'features/review/domain/repository/review_repo.dart';
import 'features/review/domain/usecases/add_review_use_case.dart';
import 'features/review/domain/usecases/delete_review_image_use_case.dart';
import 'features/review/domain/usecases/delete_review_use_case.dart';
import 'features/review/domain/usecases/get_all_reviews_use_case.dart';
import 'features/review/domain/usecases/update_review_use_case.dart';
import 'features/review/domain/usecases/upload_reveiw_images_use_case.dart';
import 'features/review/presentation/bloc/review_bloc.dart';
import 'features/search/presentation/bloc/property_search_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ============= Network ================
  sl.registerLazySingleton(() => ConnectivityCubit());
  sl.registerLazySingleton(
    () => Client()
        .setEndpoint(TextConstants.appwriteUrl)
        .setProject(Env.appWriteProjectId),
  );
  sl.registerLazySingleton(() => Storage(sl<Client>()));

  // ============= External Dependencies ===============
  sl.registerLazySingleton(() => AppRouter());
  sl.registerLazySingleton(() => SharedPreferencesAsync());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => NotificationService());

  // ============= Data layer ==============
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignInInstance: sl<GoogleSignIn>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<AppwriteStorageDataSource>(
    () => AppwriteStorageDataSourceImpl(storage: sl<Storage>()),
  );

  sl.registerLazySingleton(
    () => PropertyRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepoImpl(localDataSource: sl<OnboardingLocalDataSource>()),
  );

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // Property
  sl.registerLazySingleton<PropertyRepo>(
    () => PropertyRepoImpl(
      dataSource: sl<AppwriteStorageDataSource>(),
      firebase: sl<PropertyRemoteDataSource>(),
    ),
  );

  // Owner
  sl.registerLazySingleton<OwnerRepo>(
    () => OwnerRepoImpl(firebase: sl(), dataSource: sl()),
  );

  // Location
  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(dataSource: sl<LocationLocalDataSource>()),
  );

  // Booking
  sl.registerLazySingleton(
    () => BookingRemoteDataSource(authRemoteDataSource: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<BookingRepo>(() => BookingRepoImpl(sl()));

  // Payment
  sl.registerLazySingleton(() => EsewaRemoteDataSource());
  sl.registerLazySingleton<EsewaPaymentRepo>(() => EsewaPaymentRepoImpl(sl()));

  // chat
  sl.registerLazySingleton(
    () => ChatRemoteDataSource(firestore: sl(), auth: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(() => ChatRepoImpl(sl()));

  // review
  sl.registerLazySingleton(
    () => ReviewRemoteDataSource(storage: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(sl()));

  // profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
      firebaseAuth: sl<FirebaseAuth>(),
      appwriteStorageDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteDataSource: sl(), storageDataSource: sl()),
  );

  // payment
  sl.registerLazySingleton(() => PaymentHistoryRemoteDataSource(sl()));
  sl.registerLazySingleton<PaymentHistoryRepo>(
    () => PaymentHistoryRepoImpl(sl()),
  );

  // favorite
  sl.registerLazySingleton(() => FavoritesLocalDatasource(sl()));
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoriteRepositoryImpl(sl()),
  );

  // ============== Domain layer ===============
  sl.registerLazySingleton(
    () => SetOnboardingStatusUsecase(
      onboardingRepository: sl<OnboardingRepository>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetOnboardingStatusUsecase(
      onboardingRepository: sl<OnboardingRepository>(),
    ),
  );

  // auth use cases
  sl.registerLazySingleton(() => RegisterUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LogOutUseCase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => GoogleSigninUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => SendPasswordResetUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => AuthStateChangeUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LoginStatusUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepo>()));

  // property use cases
  sl.registerLazySingleton(() => UploadCoverImage(sl()));
  sl.registerLazySingleton(() => UploadPropertyImages(sl()));
  sl.registerLazySingleton(() => DeleteImageFile(repo: sl()));
  sl.registerLazySingleton(() => UpdateImageFile(repo: sl()));
  sl.registerLazySingleton(() => CreateProperty(repo: sl()));
  sl.registerLazySingleton(() => FetchAllProperties(sl()));
  sl.registerLazySingleton(() => UpdateProperty(sl()));
  sl.registerLazySingleton(() => DeleteProperty(sl()));
  sl.registerLazySingleton(() => SearchAndFilter(sl()));
  sl.registerLazySingleton(() => GetPropertyByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetRecommendedPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetMyPropertiesUseCase(sl()));

  // owner use case
  sl.registerLazySingleton(() => CreateOwnerProfile(sl()));
  sl.registerLazySingleton(() => GetOwnerProfile(sl()));

  // location use cases
  sl.registerLazySingleton(
    () => GetCurrentLocationUseCase(locationRepo: sl<LocationRepo>()),
  );
  sl.registerLazySingleton(
    () => CheckLocationPermissionUseCase(locationRepo: sl<LocationRepo>()),
  );
  sl.registerLazySingleton(
    () => RequestLocationPermissionUseCase(locationRepo: sl<LocationRepo>()),
  );
  sl.registerLazySingleton(
    () => CheckServiceEnabledUseCase(locationRepo: sl<LocationRepo>()),
  );

  // booking use cases
  sl.registerLazySingleton(() => RequestBookingUseCase(sl()));
  sl.registerLazySingleton(() => ListenBookingChangesUseCase(sl()));
  sl.registerLazySingleton(() => RespondBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingRequestListUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyBookingsUseCase(sl()));

  // payment use cases
  sl.registerLazySingleton(() => InitiateEsewaPayUseCase(sl()));

  // chat use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesStreamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOnlineStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetUserStatusStreamUseCase(sl()));
  sl.registerLazySingleton(() => delete_message_usecase.DeleteMessage(sl()));
  sl.registerLazySingleton(() => GetChatListUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrGetChatUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChatUseCase(sl()));
  sl.registerLazySingleton(() => mark_message.MarkMessageAsRead(sl()));
  sl.registerLazySingleton(() => SendPushNotificationUseCase(sl()));

  // review use cases
  sl.registerLazySingleton(() => UploadReveiwImagesUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetAllReviewsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));

  // profile use cases
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProfileImageUseCase(sl()));

  // payment use case
  sl.registerLazySingleton(() => GetPaymentHistoryUseCase(sl()));

  // favorite use cases
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));

  // ============= Presentation layer =================
  sl.registerFactory(
    () => OnboardingCubit(
      setUseCase: sl<SetOnboardingStatusUsecase>(),
      getUseCase: sl<GetOnboardingStatusUsecase>(),
    ),
  );

  sl.registerFactory(
    () => RegisterCubit(registerUsecase: sl<RegisterUsecase>()),
  );
  sl.registerFactory(() => LoginCubit(loginUseCase: sl<LoginUseCase>()));
  sl.registerFactory(() => LogoutCubit(logOutUseCase: sl<LogOutUseCase>()));
  sl.registerFactory(
    () => PasswordResetCubit(resetUsecase: sl<SendPasswordResetUsecase>()),
  );
  sl.registerFactory(
    () => GoogleSigninCubit(googleSigninUsecase: sl<GoogleSigninUsecase>()),
  );

  // Property bloc
  sl.registerFactory(
    () => PropertyCrudBloc(
      createProperty: sl(),
      updateProperty: sl(),
      deleteProperty: sl(),
      uploadCoverImage: sl(),
      uploadPropertyImages: sl(),
      deleteImageFile: sl(),
      getPropertyByIdUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PropertyListBloc(
      fetchAllProperties: sl(),
      getRecommendedPropertiesUseCase: sl(),
      getMyPropertiesUseCase: sl(),
    ),
  );

  sl.registerFactory(() => PropertyFormCubit());
  sl.registerFactory(() => PropertySearchBloc(sl()));

  sl.registerFactory(
    () => OwnerCubit(
      createOwnerProfile: sl(),
      uploadCoverImage: sl(),
      getOwnerProfile: sl(),
    ),
  );

  // Location cubit
  sl.registerFactory(
    () => LocationCubit(
      getCurrentLocationUseCase: sl<GetCurrentLocationUseCase>(),
      checkLocationPermissionUseCase: sl<CheckLocationPermissionUseCase>(),
      checkServiceEnabledUseCase: sl<CheckServiceEnabledUseCase>(),
      requestLocationPermissionUseCase: sl<RequestLocationPermissionUseCase>(),
    ),
  );
  sl.registerFactory(
    () => AuthCubit(
      authStateChangeUsecase: sl<AuthStateChangeUsecase>(),
      statusUsecase: sl<LoginStatusUsecase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    ),
  );

  // booking
  sl.registerFactory(
    () => BookingBloc(
      requestBookingUseCase: sl(),
      listenBookingChangesUseCase: sl(),
      respondBookingUseCase: sl(),
      getBookingRequestListUseCase: sl(),
      getPropertyBookingsUseCase: sl(),
    ),
  );

  sl.registerFactory(() => CalendarCubit());

  // Payment
  sl.registerFactory(() => PaymentBloc(sl()));

  // chat
  sl.registerFactory(
    () => ChatSessionBloc(
      sendMessageUseCase: sl(),
      getMessagesUseCase: sl(),
      deleteMessageUseCase: sl(),
      markMessagesAsRead: sl(),
      updateOnlineStatus: sl(),
      getUserStatus: sl(),
      createOrGetChat: sl(),
      sendPushNotificationUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ChatListBloc(deleteChat: sl(), getChatList: sl()));

  // review
  sl.registerFactory(
    () => ReviewBloc(
      uploadReveiwImagesUseCase: sl(),
      addReviewUseCase: sl(),
      getAllReviewsUseCase: sl(),
      updateReviewUseCase: sl(),
      deleteReviewImageUseCase: sl(),
      deleteReviewUseCase: sl(),
    ),
  );

  // profile
  sl.registerFactory(
    () => ProfileCubit(
      updateUserProfileUseCase: sl(),
      uploadCoverImage: sl(),
      deleteImageFile: sl(),
    ),
  );

  // payment
  sl.registerFactory(() => PaymentHistoryCubit(sl()));

  // favorite
  sl.registerFactory(
    () => FavoritesBloc(
      addFavoriteUseCase: sl(),
      removeFavoriteUseCase: sl(),
      getFavoritesUseCase: sl(),
      isFavoriteUseCase: sl(),
    ),
  );

  sl.registerFactory(() => NotificationCubit());
}
