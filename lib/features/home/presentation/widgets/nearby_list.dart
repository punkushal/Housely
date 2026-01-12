import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/widgets/nearby_card.dart';

class NearbyList extends StatelessWidget {
  const NearbyList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 204),
      child: GridView.builder(
        scrollDirection: .horizontal,
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: ResponsiveDimensions.getHeight(context, 94),
          mainAxisExtent: ResponsiveDimensions.getSize(context, 282),
          crossAxisSpacing: ResponsiveDimensions.spacing8(context),
          mainAxisSpacing: ResponsiveDimensions.spacing8(context),
        ),

        itemBuilder: (context, index) {
          return Column(
            spacing: ResponsiveDimensions.getHeight(context, 12),
            children: [
              // NearbyCard(navigateTo: () => context.router.push(DetailRoute())),
              Divider(color: AppColors.divider),
            ],
          );
        },
      ),
    );
  }
}
