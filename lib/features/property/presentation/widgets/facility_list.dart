import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';

class FacilityList extends StatefulWidget {
  const FacilityList({super.key});

  @override
  State<FacilityList> createState() => _FacilityListState();
}

class _FacilityListState extends State<FacilityList> {
  // The available options to display
  final _facilityOptions = [
    'Wifi',
    'AC',
    'parking',
    'Gym',
    'Gas station',
    "Swimming Pool",
  ];

  // The list where we store what the user selects
  final List<String> _selectedFacilites = [];
  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: _selectedFacilites,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select at least one facility';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _facilityOptions.map((facility) {
                final isSelected = _selectedFacilites.contains(facility);

                return FilterChip(
                  label: Text(facility),
                  selected: isSelected,
                  checkmarkColor: AppColors.surface,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.chipInActive,
                  labelStyle: AppTextStyle.bodyRegular(
                    context,
                    color: isSelected ? AppColors.surface : AppColors.textHint,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFacilites.add(facility);
                      } else {
                        _selectedFacilites.remove(facility);
                      }
                    });

                    field.didChange(_selectedFacilites);

                    // update form cubit to store the selected facilites
                    context.read<PropertyFormCubit>().updateFacilities(
                      _selectedFacilites,
                    );
                  },
                );
              }).toList(),
            ),

            // Error message display
            if (field.hasError)
              Padding(
                padding: ResponsiveDimensions.paddingOnly(context, top: 8),
                child: Text(
                  field.errorText!,
                  style: AppTextStyle.bodyRegular(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
