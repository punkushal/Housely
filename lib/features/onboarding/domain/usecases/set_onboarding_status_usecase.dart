import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingStatusUsecase implements UseCase<void, StatusParam> {
  final OnboardingRepository onboardingRepository;

  SetOnboardingStatusUsecase({required this.onboardingRepository});

  @override
  ResultFuture<void> call(StatusParam param) {
    return onboardingRepository.setOnboardingStatus(isFirstTime: param.status);
  }
}

class StatusParam extends Equatable {
  final bool status;

  const StatusParam({required this.status});

  @override
  List<Object?> get props => [status];
}
