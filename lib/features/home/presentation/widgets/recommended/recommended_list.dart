import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/features/home/presentation/widgets/big_card.dart';
import 'package:housely/features/property/domain/entities/property.dart';

import '../../../../../app/app_router.gr.dart';
import '../../../../../core/extensions/context_extension.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key, required this.propertyList});

  final List<Property> propertyList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.responsive(160),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: propertyList.take(3).length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: context.sp16),
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
