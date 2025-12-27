import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/small_card.dart';

@RoutePage()
class SeeAllListPage extends StatelessWidget {
  const SeeAllListPage({super.key, required this.appBarTitle});
  final String appBarTitle;
  // later i also accept the list parameter to display data
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        body: SafeArea(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: .min,
                    spacing: ResponsiveDimensions.getHeight(context, 12),
                    children: [
                      SmallCard(
                        height: ResponsiveDimensions.getHeight(context, 72),
                      ),
                      Divider(color: AppColors.divider),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
