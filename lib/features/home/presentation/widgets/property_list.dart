import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/widgets/small_card.dart';

class PropertyList extends StatelessWidget {
  const PropertyList({super.key, this.horizontal = 24, this.vertical = 12});

  /// horizontal padding
  final double horizontal;

  /// vertical padding
  final double vertical;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // TODO: later dynamice list item will be fetched
      itemCount: 6,
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
              spacing: ResponsiveDimensions.getHeight(context, 12),
              children: [
                SmallCard(
                  height: ResponsiveDimensions.getHeight(context, 72),
                  navigateTo: () => context.router.push(DetailRoute()),
                ),
                Divider(color: AppColors.divider),
              ],
            ),
          ),
        );
      },
    );
  }
}
