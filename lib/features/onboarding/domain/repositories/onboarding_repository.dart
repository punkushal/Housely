import 'package:housely/core/utils/typedef.dart';

abstract interface class OnboardingRepository {
  /// Set Onboarding status
  ResultVoid setOnboardingStatus({required bool isFirstTime});

  /// Get Onboarding status
  ResultFuture<bool> getOnboardingStatus();
}
