import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/favorites/domain/entity/favorite.dart';
import 'package:housely/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:housely/features/home/presentation/widgets/small_card.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class PropertyList extends StatelessWidget {
  const PropertyList({
    super.key,
    this.horizontal = 24,
    this.vertical = 12,
    required this.propertyList,
    this.showAll = false,
  });

  /// property list
  final List<Property> propertyList;

  /// horizontal padding
  final double horizontal;

  /// vertical padding
  final double vertical;

  /// boolean checker to show all
  final bool showAll;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: showAll ? propertyList.length : propertyList.take(3).length,
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
                  navigateTo: () => context.router.push(
                    DetailRoute(propertyId: propertyList[index].id!),
                  ),
                  favoriteToggle: () =>
                      _toggleFavorite(context, propertyList[index]),
                ),

                Divider(color: AppColors.divider),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Toggle favorite status for a property
  void _toggleFavorite(BuildContext context, Property property) {
    // Ensure property has an ID
    if (property.id == null) {
      // Show error if property doesn't have an ID
      SnackbarHelper.showError(
        context,
        "Cannot favorite: Property ID is missing",
      );
      return;
    }

    // Create favorite entity
    final favorite = Favorite(
      property: property,
      favoriteId: property.id!,
      addedAt: .now(),
    );

    context.read<FavoritesBloc>().add(
      ToggleFavoriteRequested(favorite: favorite, favoriteId: property.id!),
    );
  }
}
