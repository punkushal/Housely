import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/widgets/handle_error_state.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

@RoutePage()
class MyPropertyListPage extends StatefulWidget {
  const MyPropertyListPage({super.key});

  @override
  State<MyPropertyListPage> createState() => _MyPropertyListPageState();
}

class _MyPropertyListPageState extends State<MyPropertyListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authState = context.read<AuthCubit>().state as Authenticated;
      context.read<PropertyListBloc>().add(
        GetMyProperties(userId: authState.currentUser!.uid),
      );
      context.read<FavoritesBloc>().add(LoadFavoritesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My properties")),
      body: BlocBuilder<PropertyListBloc, PropertyListState>(
        builder: (context, state) {
          if (state is PropertyListLoading && state.section == .my) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PropertyListLoaded) {
            final properties = state.myProperties;

            if (properties == null) {
              return Center(
                child: Text(
                  "No properties added yet",
                  style: AppTextStyle.headingSemiBold(
                    context,
                    color: AppColors.border,
                  ),
                ),
              );
            }
            return PropertyList(propertyList: properties);
          }

          if (state is PropertyListFailure && state.section == .my) {
            return HandleErrorState(
              message: state.message,
              retry: () {
                context.read<PropertyListBloc>().add(
                  GetMyProperties(
                    userId: (context.read<AuthCubit>().state as Authenticated)
                        .currentUser!
                        .uid,
                  ),
                );
              },
            );
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
}
