import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';

class NearbyList extends StatelessWidget {
  const NearbyList({
    super.key,
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyListBloc, PropertyListState>(
      builder: (context, state) {
        // If loading nearby section specifically
        if (state is PropertyListLoading &&
            state.section == PropertySection.nearby) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PropertyListLoaded) {
          final properties = state.nearbyProperties;

          if (properties == null || properties.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            spacing: ResponsiveDimensions.spacing12(context),
            children: [
              HeadingSection(
                title: 'Nearby',
                onTapText: "See all",
                onTap: () {
                  context.router.push(
                    SeeAllListRoute(
                      appBarTitle: 'Near By Properties',
                      section: .nearby,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  );
                },
              ),
              PropertyList(
                propertyList: properties,
                isNearby: true,
                vertical: 0,
                horizontal: 0,
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
