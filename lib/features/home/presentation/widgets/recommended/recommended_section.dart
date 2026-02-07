import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';
import 'package:housely/features/home/presentation/widgets/recommended/recommended_list.dart';

import '../../../../../app/app_router.gr.dart';
import '../../../../../core/responsive/responsive_dimensions.dart';
import '../../../../../core/widgets/handle_error_state.dart';
import '../../../../property/presentation/bloc/fetch/property_list_bloc.dart';

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyListBloc, PropertyListState>(
      builder: (context, state) {
        if (state is PropertyListFailure && state.section == .recommended) {
          return HandleErrorState(
            message: state.message,
            retry: () {
              context.read<PropertyListBloc>().add(GetRecommendedProperties());
            },
          );
        }
        if (state is PropertyListLoaded) {
          final properties = state.recommendedProperties;

          if (properties == null) {
            return SizedBox.shrink();
          }

          if (properties.isEmpty) {
            return SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: .start,
            spacing: ResponsiveDimensions.spacing12(context),
            children: [
              HeadingSection(
                title: 'Recommended',
                onTapText: "See all",
                onTap: () => context.router.push(
                  SeeAllListRoute(
                    appBarTitle: "Recommended",
                    section: .recommended,
                  ),
                ),
              ),
              RecommendedList(propertyList: properties),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
