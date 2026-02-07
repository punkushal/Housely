import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingStatusUsecase implements UseCaseWithoutParams<bool> {
  final OnboardingRepository onboardingRepository;

  GetOnboardingStatusUsecase({required this.onboardingRepository});
  @override
  ResultFuture<bool> call() {
    return onboardingRepository.getOnboardingStatus();
  }
}
