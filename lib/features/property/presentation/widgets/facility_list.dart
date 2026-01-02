import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class FacilityList extends StatefulWidget {
  const FacilityList({super.key});

  @override
  State<FacilityList> createState() => _FacilityListState();
}

class _FacilityListState extends State<FacilityList> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final list = ['Wifi', 'AC', 'parking', 'Bathtubs', "Swimming Pool"];
    return SizedBox(
      height: ResponsiveDimensions.getSize(context, 36),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
            },
            child: FacilityChip(
              label: list[index],
              isActive: _currentIndex == index,
            ),
          );
        },
      ),
    );
  }
}

// Facility chip
class FacilityChip extends StatelessWidget {
  const FacilityChip({super.key, required this.label, this.isActive = false});

  /// label text
  final String label;

  /// is selected checker
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDimensions.paddingAll8(context),
      margin: ResponsiveDimensions.paddingOnly(context, right: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
        color: isActive ? AppColors.primary : AppColors.chipInActive,
      ),
      child: Text(
        label,
        style: AppTextStyle.bodyRegular(
          context,
          color: isActive ? AppColors.surface : AppColors.textHint,
        ),
      ),
    );
  }
}
