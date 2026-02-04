import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_router.gr.dart';
import '../../../../../core/widgets/handle_error_state.dart';
import '../../../../property/presentation/bloc/fetch/property_list_bloc.dart';
import '../heading_section.dart';
import '../property_list.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyListBloc, PropertyListState>(
      builder: (context, state) {
        // Handle loading state
        if (state is PropertyListLoading && state.section == .all) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (state is PropertyListFailure && state.section == .all) {
          return HandleErrorState(
            message: state.message,
            retry: () {
              context.read<PropertyListBloc>().add(GetAllProperties());
            },
          );
        }

        // Handle loaded state
        if (state is PropertyListLoaded) {
          final properties = state.allProperties;

          if (properties == null || properties.isEmpty) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              HeadingSection(
                title: "Popular for you",
                onTapText: "See all",
                onTap: () {
                  context.router.push(
                    SeeAllListRoute(
                      appBarTitle: 'Popular for you',
                      section: .all,
                    ),
                  );
                },
              ),
              PropertyList(
                horizontal: 0,
                propertyList: properties,
                showAll: false,
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
