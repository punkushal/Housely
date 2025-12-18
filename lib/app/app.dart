import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.dart';
import 'package:housely/core/theme/app_theme.dart';
import 'package:housely/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:housely/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return BlocProvider(
      create: (context) => sl<OnboardingCubit>()..checkStatus(),
      child: MaterialApp.router(
        title: 'Housely',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(context),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
