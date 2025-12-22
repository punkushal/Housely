import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:housely/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';
import 'package:housely/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:housely/features/auth/domain/usecases/login_usecase.dart';
import 'package:housely/features/auth/domain/usecases/logout_usecase.dart';
import 'package:housely/features/auth/domain/usecases/register_usecase.dart';
import 'package:housely/features/auth/presentation/cubit/google_signin_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/login_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/register_cubit.dart';
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

  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSigninUsecase(sl()));

  // ============= Presentation layer =================
  sl.registerFactory(
    () => OnboardingCubit(
      setUseCase: sl<SetOnboardingStatusUsecase>(),
      getUseCase: sl<GetOnboardingStatusUsecase>(),
    ),
  );

  sl.registerFactory(() => RegisterCubit(registerUsecase: sl()));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => LogoutCubit(logOutUseCase: sl()));
  sl.registerFactory(() => GoogleSigninCubit(googleSigninUsecase: sl()));
}
