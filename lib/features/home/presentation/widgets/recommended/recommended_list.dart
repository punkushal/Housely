import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/widgets/big_card.dart';
import 'package:housely/features/property/domain/entities/property.dart';

import '../../../../../app/app_router.gr.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key, required this.propertyList});

  final List<Property> propertyList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 164),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: propertyList.take(3).length,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(context, right: 16),
            child: BigCard(
              property: propertyList[index],
              navigateTo: () => context.router.push(
                DetailRoute(propertyId: propertyList[index].id!),
              ),
            ),
          );
        },
      ),
    );
  }
}
