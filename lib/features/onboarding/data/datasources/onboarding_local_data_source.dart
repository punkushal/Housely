import 'dart:developer';
import 'package:housely/features/onboarding/domain/enums/on_boarding_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingLocalDataSource {
  /// Set Onboarding status
  Future<void> setOnboardingStatus({required bool isFirstTime});

  /// Get Onboarding status
  Future<bool> getOnboardingStatus();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  // instance of shared preference
  final SharedPreferencesAsync prefs;

  OnboardingLocalDataSourceImpl({required this.prefs});
  @override
  Future<void> setOnboardingStatus({required bool isFirstTime}) async {
    try {
      await prefs.setBool(OnBoardingStatus.firstTime.name, isFirstTime);
    } catch (e) {
      // for now just print exception via console
      // later i will implement more efficient way
      log(
        'From Onboarding local data source : this exception occured $e while setting status',
      );
    }
  }

  @override
  Future<bool> getOnboardingStatus() async {
    try {
      return await prefs.getBool(OnBoardingStatus.firstTime.name) ?? false;
    } catch (e) {
      // for now just print exception via console
      // later i will implement more efficient way
      log(
        'From Onboarding local data source : this exception occured $e while getting status',
      );
      throw Exception(e);
    }
  }
}
