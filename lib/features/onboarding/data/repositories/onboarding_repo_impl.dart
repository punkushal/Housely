import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:housely/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepoImpl implements OnboardingRepository {
  // instance of local data source
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepoImpl({required this.localDataSource});
  @override
  ResultFuture<bool> getOnboardingStatus() async {
    try {
      final result = await localDataSource.getOnboardingStatus();
      return Right(result);
    } catch (e) {
      return Left(StorageWriteFailure());
    }
  }

  @override
  ResultVoid setOnboardingStatus({required bool isFirstTime}) async {
    try {
      await localDataSource.setOnboardingStatus(isFirstTime: isFirstTime);
      return Right(null);
    } catch (e) {
      return Left(StorageReadFailure());
    }
  }
}
