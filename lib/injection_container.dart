import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/env/env.dart';
import 'package:housely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:housely/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';
import 'package:housely/features/auth/domain/usecases/auth_state_change_usecase.dart';
import 'package:housely/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:housely/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:housely/features/auth/domain/usecases/login_status_usecase.dart';
import 'package:housely/features/auth/domain/usecases/login_usecase.dart';
import 'package:housely/features/auth/domain/usecases/logout_usecase.dart';
import 'package:housely/features/auth/domain/usecases/register_usecase.dart';
import 'package:housely/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/google_signin_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/login_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/register_cubit.dart';
import 'package:housely/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:housely/features/booking/data/datasources/esewa_remote_data_source.dart';
import 'package:housely/features/booking/data/repository/booking_repo_impl.dart';
import 'package:housely/features/booking/data/repository/esewa_payment_repo_impl.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';
import 'package:housely/features/booking/domain/repository/esewa_payment_repo.dart';
import 'package:housely/features/booking/domain/usecases/get_booking_request_list_use_case.dart';
import 'package:housely/features/booking/domain/usecases/initiate_esewa_pay_use_case.dart';
import 'package:housely/features/booking/domain/usecases/listen_booking_changes_use_case.dart';
import 'package:housely/features/booking/domain/usecases/request_booking_use_case.dart';
import 'package:housely/features/booking/domain/usecases/respond_booking_use_case.dart';
import 'package:housely/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:housely/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:housely/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:housely/features/chat/data/repository/chat_repo_impl.dart';
import 'package:housely/features/chat/domain/usecases/get_chat_room_id_use_case.dart';
import 'package:housely/features/chat/domain/usecases/get_chat_rooms_use_case.dart';
import 'package:housely/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:housely/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:housely/features/chat/presentation/bloc/chat_session_bloc.dart';
import 'package:housely/features/location/data/datasources/location_local_data_source.dart';
import 'package:housely/features/location/data/repositories/location_repo_impl.dart';
import 'package:housely/features/location/domain/repositories/location_repo.dart';
import 'package:housely/features/location/domain/usecases/check_location_permission_use_case.dart';
import 'package:housely/features/location/domain/usecases/check_service_enabled_use_case.dart';
import 'package:housely/features/location/domain/usecases/get_current_location_use_case.dart';
import 'package:housely/features/location/domain/usecases/request_location_permission_use_case.dart';
import 'package:housely/features/location/presentation/cubit/location_cubit.dart';
import 'package:housely/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:housely/features/onboarding/data/repositories/onboarding_repo_impl.dart';
import 'package:housely/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:housely/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:housely/features/onboarding/domain/usecases/set_onboarding_status_usecase.dart';
import 'package:housely/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:housely/features/property/data/datasources/app_write_data_source.dart';
import 'package:housely/features/property/data/datasources/firebase_remote_data_source.dart';
import 'package:housely/features/property/data/repository/owner_repo_impl.dart';
import 'package:housely/features/property/data/repository/property_repo_impl.dart';
import 'package:housely/features/property/domain/repository/owner_repo.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';
import 'package:housely/features/property/domain/usecases/create_owner_profile.dart';
import 'package:housely/features/property/domain/usecases/create_property.dart';
import 'package:housely/features/property/domain/usecases/delete_image_file.dart';
import 'package:housely/features/property/domain/usecases/delete_property.dart';
import 'package:housely/features/property/domain/usecases/fetch_all_properties.dart';
import 'package:housely/features/property/domain/usecases/get_owner_profile.dart';
import 'package:housely/features/property/domain/usecases/search_and_filter.dart';
import 'package:housely/features/property/domain/usecases/update_image_file.dart';
import 'package:housely/features/property/domain/usecases/update_property.dart';
import 'package:housely/features/property/domain/usecases/upload_cover_image.dart';
import 'package:housely/features/property/domain/usecases/upload_property_images.dart';
import 'package:housely/features/property/presentation/bloc/property_bloc.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/search/presentation/bloc/property_search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  sl.registerLazySingleton(() => SharedPreferencesAsync());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);

  // ============= Data layer ==============
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignInInstance: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<AppwriteStorageDataSource>(
    () => AppwriteStorageDataSourceImpl(storage: sl<Storage>()),
  );

  sl.registerLazySingleton(
    () => FirebaseRemoteDataSource(
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
      firebase: sl<FirebaseRemoteDataSource>(),
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
  sl.registerLazySingleton(() => ChatRepoImpl(sl()));

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

  // payment use cases
  sl.registerLazySingleton(() => InitiateEsewaPayUseCase(sl()));

  // chat use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => GetChatRoomsUseCase(sl()));
  sl.registerLazySingleton(() => GetChatRoomIdUseCase(sl()));

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

  // Property cubit
  sl.registerFactory(
    () => PropertyCubit(
      uploadCoverImage: sl(),
      uploadPropertyImages: sl(),
      deleteImageFile: sl(),
      createProperty: sl(),
      updateImageFile: sl(),
      updateProperty: sl(),
      deleteProperty: sl(),
    ),
  );
  sl.registerFactory(() => PropertyFormCubit());
  sl.registerLazySingleton(() => PropertyBloc(sl()));
  sl.registerLazySingleton(() => PropertySearchBloc(sl()));

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
      getChatRoomsUseCase: sl(),
      getChatRoomIdUseCase: sl(),
    ),
  );
}
