import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/property/presentation/bloc/property_bloc.dart';
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
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                child: Column(
                  spacing: ResponsiveDimensions.spacing40(context),
                  children: [
                    // search text field
                    CustomTextField(
                      controller: _controller,
                      prefixIcon: SvgPicture.asset(
                        ImageConstant.searchIcon,
                        height: ResponsiveDimensions.getHeight(context, 24),
                        width: ResponsiveDimensions.getSize(context, 24),
                        fit: .scaleDown,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => showFitlerSheet(context),
                        child: SvgPicture.asset(
                          ImageConstant.filterIcon,
                          height: ResponsiveDimensions.getHeight(context, 24),
                          width: ResponsiveDimensions.getSize(context, 24),
                          fit: .scaleDown,
                        ),
                      ),
                      hintText: "Search Property",
                      contentPadding: ResponsiveDimensions.paddingSymmetric(
                        context,
                        horizontal: 16,
                        vertical: 14,
                      ),
                      onChanged: (value) {
                        context.read<PropertySearchBloc>().add(
                          GetSearchAndFilterProperties(
                            filterParams: PropertyFilterParams(
                              searchQuery: value,
                            ),
                          ),
                        );
                      },
                    ),

                    // result list
                    BlocBuilder<PropertySearchBloc, PropertySearchState>(
                      builder: (context, state) {
                        if (state is PropertyFetchLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is PropertySearchAndFilterLoaded) {
                          if (state.allProperties.isEmpty) {
                            return Padding(
                              padding: ResponsiveDimensions.paddingSymmetric(
                                context,
                                horizontal: 33,
                              ),
                              child: Column(
                                spacing: ResponsiveDimensions.spacing16(
                                  context,
                                ),
                                children: [
                                  SizedBox(
                                    height: ResponsiveDimensions.spacing20(
                                      context,
                                    ),
                                  ),
                                  Image.asset(ImageConstant.searchNotFoundmg),
                                  SizedBox(
                                    height: ResponsiveDimensions.spacing8(
                                      context,
                                    ),
                                  ),
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
                          return ResultList(propertyList: state.allProperties);
                        }

                        if (state is PropertySearchError) {
                          return Center(
                            child: Text(state.message, overflow: .ellipsis),
                          );
                        }

                        return SizedBox.shrink();
                      },
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
}
