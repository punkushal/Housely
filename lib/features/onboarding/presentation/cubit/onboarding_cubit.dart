import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:housely/features/onboarding/domain/usecases/set_onboarding_status_usecase.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SetOnboardingStatusUsecase setUseCase;
  final GetOnboardingStatusUsecase getUseCase;
  OnboardingCubit({required this.setUseCase, required this.getUseCase})
    : super(OnboardingInitial());

  void onPageChanged(int page, int pages) {
    emit(OnboardingPageChanged(currentPage: page, totalPages: pages));
  }

  // move to next page
  void nextPage(PageController controller) {
    if (state is OnboardingPageChanged) {
      final currentState = state as OnboardingPageChanged;
      if (!currentState.isLastPage) {
        controller.nextPage(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // skip to last page
  void skipToLast(PageController controller, int lastPage) {
    controller.jumpToPage(lastPage);
  }

  // check status whether first time or not
  Future<void> checkStatus() async {
    final result = await getUseCase();
    result.fold(
      (failure) => emit(OnboardingError("Error while processing onboard")),
      (status) {
        status == true
            ? emit(OnboardingCompleted())
            : emit(OnboardingInitial());
      },
    );
  }

  Future<void> completeOnboarding() async {
    await setUseCase(StatusParam(status: true));
    emit(OnboardingCompleted());
  }
}
