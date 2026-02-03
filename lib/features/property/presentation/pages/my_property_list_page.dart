import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'package:housely/injection_container.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

@RoutePage()
class MyPropertyListPage extends StatefulWidget implements AutoRouteWrapper {
  const MyPropertyListPage({super.key});

  @override
  State<MyPropertyListPage> createState() => _MyPropertyListPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final authState = context.read<AuthCubit>().state as Authenticated;

    return BlocProvider(
      create: (context) =>
          sl<PropertyListBloc>()
            ..add(GetMyProperties(userId: authState.currentUser!.uid)),
      child: this,
    );
  }
}

class _MyPropertyListPageState extends State<MyPropertyListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FavoritesBloc>().add(LoadFavoritesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My properties")),
      body: BlocBuilder<PropertyListBloc, PropertyListState>(
        builder: (context, state) {
          if (state is PropertyListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PropertyListLoaded && state.allProperties.isNotEmpty) {
            return PropertyList(propertyList: state.allProperties);
          }

          if (state is PropertyListFailure) {
            return _buildErrorState(state.message);
          }
          return Center(
            child: Text(
              "No properties added yet",
              style: AppTextStyle.headingSemiBold(
                context,
                color: AppColors.border,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? 'Failed to load property'),
          const SizedBox(height: 16),
          CustomButton(
            onTap: () {
              // Retry loading
              context.read<PropertyListBloc>().add(
                GetMyProperties(
                  userId: (context.read<AuthCubit>().state as Authenticated)
                      .currentUser!
                      .uid,
                ),
              );
            },
            buttonLabel: 'Retry',
          ),
        ],
      ),
    );
  }
}
