part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingPageChanged extends OnboardingState {
  final int currentPage;
  final int totalPages;

  const OnboardingPageChanged({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [currentPage, totalPages];
}

final class OnboardingCompleted extends OnboardingState {}
