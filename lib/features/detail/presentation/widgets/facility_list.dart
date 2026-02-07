import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/facility_chip.dart';

class FacilityList extends StatelessWidget {
  const FacilityList({super.key, required this.facilities});
  final List<String> facilities;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getSize(context, 30),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          return FacilityChip(label: facilities[index]);
        },
      ),
    );
  }
}
