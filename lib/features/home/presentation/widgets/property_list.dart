import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/small_card.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class PropertyList extends StatelessWidget {
  const PropertyList({
    super.key,
    this.horizontal = 24,
    this.vertical = 12,
    required this.propertyList,
  });

  /// property list
  final List<Property> propertyList;

  /// horizontal padding
  final double horizontal;

  /// vertical padding
  final double vertical;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: ListView.builder(
        itemCount: propertyList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: horizontal,
              vertical: vertical,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: .min,
                spacing: ResponsiveDimensions.getSize(context, 12),
                children: [
                  SmallCard(
                    property: propertyList[index],
                    height: ResponsiveDimensions.getSize(context, 72),
                    navigateTo: () => context.router.push(DetailRoute()),
                  ),
                  Divider(color: AppColors.divider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
