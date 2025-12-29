import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:housely/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';
import 'package:housely/features/auth/domain/usecases/auth_state_change_usecase.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ============= Network ================
  sl.registerLazySingleton(() => ConnectivityCubit());

  // ============= External Dependencies ===============
  sl.registerLazySingleton(() => SharedPreferencesAsync());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
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

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepoImpl(localDataSource: sl<OnboardingLocalDataSource>()),
  );

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(dataSource: sl<LocationLocalDataSource>()),
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

  sl.registerLazySingleton(() => RegisterUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LogOutUseCase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => GoogleSigninUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => SendPasswordResetUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => AuthStateChangeUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton(() => LoginStatusUsecase(sl<AuthRepo>()));
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
    ),
  );
}
