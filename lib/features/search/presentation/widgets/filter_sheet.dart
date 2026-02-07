import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/search/presentation/bloc/property_search_bloc.dart';
import 'package:housely/features/search/presentation/cubit/search_filter_cubit.dart';
import 'package:housely/features/search/presentation/widgets/facitlity_filter_chip_list.dart';
import 'package:housely/features/search/presentation/widgets/price_range_slider.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  void applyFilters(BuildContext context) {
    final filterState = context.read<SearchFilterCubit>().state;

    // Geting the filtered lists using the new getters
    final List<String> selectedStatus = filterState.selectedLookingFor;
    final List<String> selectedTypes = filterState.selectedPropertyTypes;
    final List<String> selectedFacilities = filterState.facilities.toList();

    context.read<PropertySearchBloc>().add(
      GetSearchAndFilterProperties(
        filterParams: PropertyFilterParams(
          priceRange: filterState.priceRange,
          propertyStatus: selectedStatus,
          propertyTypes: selectedTypes,
          facilities: selectedFacilities,
        ),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
      child: Column(
        spacing: ResponsiveDimensions.spacing8(context),
        children: [
          SizedBox(height: ResponsiveDimensions.spacing8(context)),
          HeadingLabel(label: "Filter"),

          // check box for property status
          BlocBuilder<SearchFilterCubit, SearchFilterState>(
            builder: (context, state) {
              return FilterCheckboxContent(
                label: "Looking for",
                checkOptions: state.lookingFor,
                onChanged: (updatedOptions) {
                  context.read<SearchFilterCubit>().togglePropertyStatus(
                    updatedOptions,
                  );
                },
              );
            },
          ),

          // check box for property type
          BlocBuilder<SearchFilterCubit, SearchFilterState>(
            builder: (context, state) {
              return FilterCheckboxContent(
                label: "Property Type",
                checkOptions: state.propertyType,
                onChanged: (updatedOptions) {
                  context.read<SearchFilterCubit>().togglePropertyType(
                    updatedOptions,
                  );
                },
              );
            },
          ),

          // price range
          PriceRangeSlider(),

          // facility filter chip
          FacitlityFilterChipList(),
          SizedBox(height: ResponsiveDimensions.spacing12(context)),
          Row(
            children: [
              // reset button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<PropertySearchBloc>().add(
                      PropertySearchAndFilterReset(),
                    );
                    context.read<SearchFilterCubit>().resetFilters();
                  },
                  child: Text(
                    "Reset",
                    style: AppTextStyle.bodyMedium(
                      context,
                      fontSize: 18,
                      lineHeight: 27,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),

              // apply button
              Expanded(
                child: CustomButton(
                  onTap: () => applyFilters(context),
                  buttonLabel: "Apply",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// selection content
class FilterCheckboxContent extends StatelessWidget {
  const FilterCheckboxContent({
    super.key,
    required this.label,
    required this.checkOptions,
    required this.onChanged,
  });

  /// label text
  final String label;

  final Map<String, bool> checkOptions;

  final Function(String key) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.spacing16(context),
      children: [
        SizedBox(height: ResponsiveDimensions.spacing8(context)),
        HeadingLabel(label: label),
        Wrap(
          children: checkOptions.entries
              .map(
                (option) => Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(option.key, style: AppTextStyle.bodyRegular(context)),
                    Checkbox(
                      value: option.value,
                      onChanged: (value) {
                        onChanged(option.key);
                      },
                      visualDensity: VisualDensity(
                        vertical: VisualDensity.minimumDensity,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
