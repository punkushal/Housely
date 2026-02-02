import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/responsive/responsive_dimensions.dart';
import '../bloc/favorites_bloc.dart';

class FavoriteToggleButton extends StatelessWidget {
  const FavoriteToggleButton({
    super.key,
    required this.propertyId,
    required this.favoriteToggle,
  });
  final String propertyId;
  final void Function()? favoriteToggle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: favoriteToggle,
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          bool isFav = _isFavorited(state, propertyId);

          return SvgPicture.asset(
            isFav
                ? ImageConstant.favoriteFilledIcon
                : ImageConstant.favoriteIcon,
            width: ResponsiveDimensions.getSize(context, 24),
            height: ResponsiveDimensions.getHeight(context, 24),
            fit: .scaleDown,
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
}
