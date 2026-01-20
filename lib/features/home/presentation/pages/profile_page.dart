import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LogoutCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LogoutCubit, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                context.router.replace(LoginRoute());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await context.read<LogoutCubit>().logout();
                    },
                    icon: Icon(Icons.logout_outlined),
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  spacing: ResponsiveDimensions.spacing16(context),
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.router.push(BookingRequestRoute());
                      },
                      child: Text('Booking request'),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(MyPropertyListRoute());
                      },
                      child: Text('property list'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
