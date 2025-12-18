import 'package:get_it/get_it.dart';
import 'package:housely/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:housely/features/onboarding/data/repositories/onboarding_repo_impl.dart';
import 'package:housely/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:housely/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:housely/features/onboarding/domain/usecases/set_onboarding_status_usecase.dart';
import 'package:housely/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  sl.registerLazySingleton(() => SharedPreferencesAsync());

  // Data layer
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepoImpl(localDataSource: sl<OnboardingLocalDataSource>()),
  );

  // Domain layer
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

  // Presentation layer
  sl.registerFactory(
    () => OnboardingCubit(
      setUseCase: sl<SetOnboardingStatusUsecase>(),
      getUseCase: sl<GetOnboardingStatusUsecase>(),
    ),
  );
}
