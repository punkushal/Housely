import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/search/presentation/bloc/property_search_bloc.dart';
import 'package:housely/features/search/presentation/cubit/search_filter_cubit.dart';

class ResultList extends StatelessWidget {
  const ResultList({
    super.key,
    required this.propertyList,
    required this.itemCount,
    required this.activeFilters,
  });
  final List<Property> propertyList;
  final int itemCount;
  final PropertyFilterParams activeFilters;

  // Helper to remove a specific filter and trigger a new search
  void _removeFilter(BuildContext context, String type, dynamic value) {
    final filterCubit = context.read<SearchFilterCubit>();

    // Update both the cubit state AND trigger search
    if (type == 'status') {
      filterCubit.togglePropertyStatus(value);
    } else if (type == 'type') {
      filterCubit.togglePropertyType(value);
    } else if (type == 'facility') {
      filterCubit.toggleFacility(value);
    } else if (type == 'price') {
      filterCubit.updatePriceRange(const RangeValues(10, 1000));
    }

    // Get updated state and trigger search
    final updatedState = filterCubit.state;
    context.read<PropertySearchBloc>().add(
      GetSearchAndFilterProperties(
        filterParams: PropertyFilterParams(
          priceRange: updatedState.priceRange,
          propertyStatus: updatedState.selectedLookingFor,
          propertyTypes: updatedState.selectedPropertyTypes,
          facilities: updatedState.facilities.toList(),
          searchQuery: activeFilters.searchQuery, // Preserve search query
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        BlocBuilder<SearchFilterCubit, SearchFilterState>(
          builder: (context, state) {
            if (state.selectedLookingFor.isNotEmpty ||
                state.selectedPropertyTypes.isNotEmpty ||
                state.facilities.isNotEmpty ||
                state.isPriceRangeActive) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Map Status
                      ...state.selectedLookingFor.map(
                        (status) => ResultFilterChip(
                          label: status.capitalize,
                          onDeleted: () =>
                              _removeFilter(context, 'status', status),
                        ),
                      ),
                      // Map Types
                      ...state.selectedPropertyTypes.map(
                        (type) => ResultFilterChip(
                          label: type.capitalize,
                          onDeleted: () => _removeFilter(context, 'type', type),
                        ),
                      ),
                      // Map Facilities
                      ...state.facilities.map(
                        (facility) => ResultFilterChip(
                          label: facility,
                          onDeleted: () =>
                              _removeFilter(context, 'facility', facility),
                        ),
                      ),
                      // Map Price (Only show if not default)
                      if (state.isPriceRangeActive)
                        ResultFilterChip(
                          label:
                              "\$${state.priceRange!.start.toInt()} - \$${state.priceRange!.end.toInt()}",
                          onDeleted: () =>
                              _removeFilter(context, 'price', null),
                        ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox.fromSize();
          },
        ),

        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index > propertyList.length) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: ResponsiveDimensions.paddingOnly(context, bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    context.router.push(
                      DetailRoute(property: propertyList[index]),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      index == 0
                          ? Padding(
                              padding: ResponsiveDimensions.paddingOnly(
                                context,
                                bottom: 16,
                              ),
                              child: HeadingLabel(label: "Result"),
                            )
                          : SizedBox.shrink(),
                      Row(
                        crossAxisAlignment: .start,
                        spacing: ResponsiveDimensions.spacing12(context),
                        children: [
                          SvgPicture.asset(
                            ImageConstant.locationIcon,
                            width: ResponsiveDimensions.spacing24(context),
                            height: ResponsiveDimensions.spacing24(context),
                            colorFilter: ColorFilter.mode(
                              AppColors.textPrimary,
                              .srcIn,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              // property name
                              Text(
                                propertyList[index].name.capitalize,
                                style: AppTextStyle.bodySemiBold(
                                  context,
                                  fontSize: 12,
                                ),
                              ),

                              // location
                              Text(
                                propertyList[index].location.address.capitalize,
                                style: AppTextStyle.bodyRegular(
                                  context,
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveDimensions.spacing12(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // divider
                      Padding(
                        padding: ResponsiveDimensions.paddingOnly(
                          context,
                          left: 36,
                        ),
                        child: SizedBox(
                          width: .infinity,
                          child: Divider(color: AppColors.textHint),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ResultFilterChip extends StatelessWidget {
  const ResultFilterChip({super.key, this.onDeleted, required this.label});
  final String label;
  final void Function()? onDeleted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingOnly(context, right: 8),
      child: Chip(
        label: Text(label, style: AppTextStyle.bodyMedium(context)),
        side: BorderSide(color: AppColors.primary),
        onDeleted: onDeleted,
        padding: .zero,
        deleteIcon: Icon(Icons.close, color: AppColors.error),
      ),
    );
  }
}
