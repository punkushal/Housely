import 'package:housely/core/utils/typedef.dart';

abstract interface class OnboardingRepository {
  /// Set Onboarding status
  ResultVoid setOnboardingStatus();

  /// Get Onboarding status
  ResultFuture<bool> getOnboardingStatus();
}
