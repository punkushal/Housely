import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/onboarding/presentation/cubit/onboarding_cubit.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late AnimationController controller;
  late AnimationController fadeController;
  @override
  void initState() {
    super.initState();
    // controllers
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // animations
    scaleAnimation = Tween<double>(begin: 1.6, end: 1).animate(controller);
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(fadeController);

    // listen status of the controller
    controller.addStatusListener((status) async {
      if (status.isCompleted) {
        fadeController.forward();
        await _handleNavigation();
      }
    });

    // start the animation
    controller.forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    final state = context.read<OnboardingCubit>().state;
    await Future.delayed(Duration(milliseconds: 1200));
    if (state is OnboardingInitial && mounted) {
      await context.router.replace(const OnboardingRoute());
    }
    if (state is OnboardingCompleted && mounted) {
      await context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: ResponsiveDimensions.spacing20(context),
          children: [
            // Logo Icon
            ScaleTransition(
              scale: scaleAnimation,
              child: Image.asset(
                ImageConstant.logoIcon,
                height: ResponsiveDimensions.getSize(context, 105),
                width: ResponsiveDimensions.getSize(context, 80),
              ),
            ),

            // App name
            FadeTransition(
              opacity: fadeAnimation,
              child: Text(
                'HOUSELY',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                  // letter spacing logic = % letter spacing from figma * font size
                  letterSpacing: ResponsiveDimensions.getSize(
                    context,
                    0.16 * 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
