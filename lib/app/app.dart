import 'package:flutter/material.dart';
import 'package:housely/app/app_router.dart';
import 'package:housely/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      title: 'Housely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(context),
      routerConfig: appRouter.config(),
    );
  }
}
