import 'package:flutter/material.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/facility_chip.dart';

class FacilityList extends StatelessWidget {
  const FacilityList({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: later i will implement dynamic content
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 30),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return FacilityChip(
            iconPath: ImageConstant.hospitalIcon,
            label: "Hospital",
          );
        },
      ),
    );
  }
}
