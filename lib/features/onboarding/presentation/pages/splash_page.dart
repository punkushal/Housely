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

  bool _animationCompleted = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Initialize animations
    scaleAnimation = Tween<double>(
      begin: 1.6,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeIn));

    // Chain animations
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fadeController.forward();
      }
    });

    // Mark animation as completed and try to navigate
    fadeController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 800));
        setState(() {
          _animationCompleted = true;
        });
        _tryNavigate();
      }
    });

    // Start animation
    controller.forward();
  }

  //  Navigate only when both animation is done AND state is loaded
  void _tryNavigate() {
    if (_hasNavigated || !_animationCompleted || !mounted) return;

    final state = context.read<OnboardingCubit>().state;

    // Only navigate if we have a definitive state (not loading/initial)
    if (state is OnboardingCompleted) {
      _hasNavigated = true;
      context.router.replace(const LocationRoute());
    } else if (state is OnboardingInitial) {
      _hasNavigated = true;
      context.router.replace(const OnboardingRoute());
    } else if (state is OnboardingError) {
      _hasNavigated = true;
      // On error, default to showing onboarding
      context.router.replace(const OnboardingRoute());
    }
    // If state is still loading, BlocListener will handle it
  }

  @override
  void dispose() {
    fadeController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        //  When state changes (checkStatus completes), try to navigate
        if (_animationCompleted) {
          _tryNavigate();
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
