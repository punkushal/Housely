import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/onboarding/data/on_boarding_data.dart';
import 'package:housely/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:housely/features/onboarding/presentation/widgets/page_view_list.dart';
import 'package:housely/features/onboarding/presentation/widgets/skip_button.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OnboardingCubit>().onPageChanged(0, pages.length);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNextButton() async {
    final cubit = context.read<OnboardingCubit>();
    final state = cubit.state;

    if (state is OnboardingPageChanged && !state.isLastPage) {
      cubit.nextPage(_controller);
    } else {
      cubit.completeOnboarding();
      await context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingPageChanged && !state.isLastPage) {
                return SkipButton(
                  onTap: () {
                    context.read<OnboardingCubit>().skipToLast(
                      _controller,
                      pages.length - 1,
                    );
                  },
                );
              }

              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        spacing: ResponsiveDimensions.spacing24(context),
        children: [
          // Page view
          Expanded(
            child: PageViewList(
              controller: _controller,
              onPageChanged: (value) {
                context.read<OnboardingCubit>().onPageChanged(
                  value,
                  pages.length,
                );
              },
              pages: pages,
            ),
          ),

          // Dot indicators
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              int currentIndex = 0;
              if (state is OnboardingPageChanged) {
                currentIndex = state.currentPage;
              }
              return Row(
                spacing: ResponsiveDimensions.spacing8(context),
                mainAxisAlignment: .center,
                children: List.generate(pages.length, (index) {
                  final isActive = currentIndex == index;
                  return Container(
                    height: ResponsiveDimensions.getSize(context, 10),
                    width: isActive
                        ? ResponsiveDimensions.getSize(context, 28)
                        : ResponsiveDimensions.getSize(context, 10),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.border,
                      borderRadius: isActive
                          ? BorderRadius.circular(
                              ResponsiveDimensions.radiusLarge(context),
                            )
                          : null,
                      shape: isActive ? .rectangle : .circle,
                    ),
                  );
                }),
              );
            },
          ),

          SizedBox(height: ResponsiveDimensions.getHeight(context, 20)),

          // Next button
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              bool isLastPage = false;
              if (state is OnboardingPageChanged) {
                isLastPage = state.isLastPage;
              }
              return CustomButton(
                onTap: _handleNextButton,
                horizontal: 24,
                child: Text(
                  isLastPage ? "Get Started" : 'Next',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.surface,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: ResponsiveDimensions.getHeight(context, 20)),
        ],
      ),
    );
  }
}
