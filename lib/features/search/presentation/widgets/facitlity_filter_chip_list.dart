import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/search/presentation/cubit/search_filter_cubit.dart';

class FacitlityFilterChipList extends StatefulWidget {
  const FacitlityFilterChipList({super.key});

  @override
  State<FacitlityFilterChipList> createState() =>
      _FacitlityFilterChipListState();
}

class _FacitlityFilterChipListState extends State<FacitlityFilterChipList> {
  final facilityList = [
    "Parking",
    "Swimming Pool",
    "Gym",
    "Hospital",
    "Gas Station",
  ];
  int currnetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: context.sp12,
      children: [
        HeadingLabel(label: "Facilities"),
        SizedBox(
          height: context.responsive(56),
          child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
            builder: (context, state) {
              return ListView.builder(
                scrollDirection: .horizontal,
                itemCount: facilityList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<SearchFilterCubit>().toggleFacility(
                        facilityList[index],
                      );
                    },
                    child: FacilityFilterChip(
                      label: facilityList[index],
                      isActive: state.facilities.contains(facilityList[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class FacilityFilterChip extends StatelessWidget {
  const FacilityFilterChip({
    super.key,
    required this.label,
    this.isActive = false,
  });

  final String label;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: context.sp12, vertical: 4),
      margin: .only(right: context.sp8),
      alignment: .center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp8),
        color: isActive
            ? AppColors.primaryPressed.withValues(alpha: 0.3)
            : null,
        border: Border.all(color: AppColors.primaryPressed),
      ),
      child: Text(
        label,
        style: AppTextStyle.bodyRegular(context, color: AppColors.primary),
      ),
    );
  }
}
