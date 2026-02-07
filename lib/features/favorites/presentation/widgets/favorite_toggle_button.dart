import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/responsive/responsive_dimensions.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../property/domain/entities/property.dart';
import '../../domain/entity/favorite.dart';
import '../bloc/favorites_bloc.dart';

class FavoriteToggleButton extends StatelessWidget {
  const FavoriteToggleButton({super.key, required this.property});
  final Property property;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleFavorite(context, property);
      },
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          bool isFav = _isFavorited(state, property.id);

          return SvgPicture.asset(
            isFav
                ? ImageConstant.favoriteFilledIcon
                : ImageConstant.favoriteIcon,
            width: ResponsiveDimensions.getSize(context, 24),
            height: ResponsiveDimensions.getHeight(context, 24),
            colorFilter: ColorFilter.mode(AppColors.error, .srcIn),
          );
        },
      ),
    );
  }

  // helper method to check if property is favorited
  bool _isFavorited(FavoritesState state, String? propertyId) {
    if (propertyId == null) return false;

    return switch (state) {
      // When favorites are loaded, check if this property is in the list
      FavoritesLoaded(:final favorites) => favorites.any(
        (f) => f.favoriteId == propertyId,
      ),

      // After adding, check the updated list
      FavoriteAdded(:final favorites) => favorites.any(
        (f) => f.favoriteId == propertyId,
      ),

      // After removing, check the updated list
      FavoriteRemoved(:final favorites) => favorites.any(
        (f) => f.favoriteId == propertyId,
      ),

      // Default cases (initial, loading, error)
      _ => false,
    };
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
