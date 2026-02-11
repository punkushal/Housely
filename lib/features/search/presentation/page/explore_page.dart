import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/search/presentation/bloc/property_search_bloc.dart';
import 'package:housely/features/search/presentation/cubit/search_filter_cubit.dart';
import 'package:housely/features/search/presentation/widgets/filter_sheet.dart';
import 'package:housely/features/search/presentation/widgets/result_list.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ExplorePage extends StatefulWidget implements AutoRouteWrapper {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PropertySearchBloc>(),
      child: this,
    );
  }
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _controller = .new();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showFitlerSheet(BuildContext context) {
    // Capture the existing cubit and search bloc instance from the current context
    final filterCubit = context.read<SearchFilterCubit>();
    final searchBloc = context.read<PropertySearchBloc>();
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: filterCubit),
          BlocProvider.value(value: searchBloc),
        ],
        child: FilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchFilterCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Explore')),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.sp24),
                child: Column(
                  spacing: context.sp16,
                  children: [
                    // search text field
                    CustomTextField(
                      controller: _controller,
                      prefixIcon: SvgPicture.asset(
                        ImageConstant.searchIcon,
                        height: context.sp24,
                        width: context.sp24,
                        fit: .scaleDown,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => showFitlerSheet(context),
                        child: SvgPicture.asset(
                          ImageConstant.filterIcon,
                          height: context.sp24,
                          width: context.sp24,
                          fit: .scaleDown,
                        ),
                      ),
                      hintText: "Search Property",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.sp16,
                        vertical: context.responsive(14),
                      ),

                      onChanged: (value) {
                        // Get current filter state from cubit
                        final filterState = context
                            .read<SearchFilterCubit>()
                            .state;

                        if (value.isEmpty &&
                            !filterState.isPriceRangeActive &&
                            filterState.facilities.isEmpty &&
                            filterState.selectedPropertyTypes.isEmpty &&
                            filterState.selectedLookingFor.isEmpty) {
                          context.read<PropertySearchBloc>().add(
                            PropertySearchAndFilterReset(),
                          );
                          return;
                        }
                        // Create filter params from current cubit state
                        final filterParams = PropertyFilterParams(
                          priceRange: filterState.priceRange,
                          propertyStatus: filterState.selectedLookingFor,
                          propertyTypes: filterState.selectedPropertyTypes,
                          facilities: filterState.facilities.toList(),
                          searchQuery: value.isEmpty
                              ? null
                              : value, // Set to null if empty
                        );

                        // Always trigger search with current filters + search query
                        context.read<PropertySearchBloc>().add(
                          GetSearchAndFilterProperties(
                            filterParams: filterParams,
                          ),
                        );
                      },
                    ),

                    // result list
                    Expanded(
                      child: BlocBuilder<PropertySearchBloc, PropertySearchState>(
                        builder: (context, state) {
                          if (state is PropertySearchLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is PropertySearchAndFilterLoaded) {
                            if (state.allProperties.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.responsive(33),
                                ),
                                child: Column(
                                  spacing: context.sp16,
                                  children: [
                                    SizedBox(height: context.sp20),
                                    Image.asset(ImageConstant.searchNotFoundmg),
                                    SizedBox(height: context.sp8),
                                    Text(
                                      "Search not found",
                                      style: AppTextStyle.headingSemiBold(
                                        context,
                                        fontSize: 20,
                                        lineHeight: 26,
                                      ),
                                    ),

                                    Text(
                                      "Please enable your location services for more optimal result",
                                      textAlign: .center,
                                      style: AppTextStyle.bodyRegular(
                                        context,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (!state.activeFilters.hasActiveFilters) {
                              return SizedBox.shrink();
                            }
                            return NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification.metrics.pixels >=
                                    notification.metrics.maxScrollExtent -
                                        200) {
                                  context.read<PropertySearchBloc>().add(
                                    LoadMoreProperties(),
                                  );
                                }
                                return false;
                              },
                              child: ResultList(
                                itemCount:
                                    state.allProperties.length +
                                    (state.hasReachedMax ? 0 : 1),
                                propertyList: state.allProperties,
                                activeFilters: state.activeFilters,
                              ),
                            );
                          }

                          if (state is PropertySearchError) {
                            return Center(
                              child: Text(state.message, overflow: .ellipsis),
                            );
                          }

                          return _buildInitialState();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // initial state
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: context.sp8,
        children: [
          Icon(
            Icons.search,
            size: context.responsive(80),
            color: Colors.grey[400],
          ),
          SizedBox(height: context.sp8),
          Text(
            'Search for properties',
            style: AppTextStyle.headingSemiBold(context, fontSize: 20),
          ),

          Text(
            'Use the search bar or filters to find properties',
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
