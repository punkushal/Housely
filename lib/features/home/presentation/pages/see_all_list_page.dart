import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/widgets/handle_error_state.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'package:housely/injection_container.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/property_list.dart';

@RoutePage()
class SeeAllListPage extends StatefulWidget implements AutoRouteWrapper {
  const SeeAllListPage({
    super.key,
    required this.appBarTitle,
    required this.section,
  });

  final String appBarTitle;
  final PropertySection section;

  @override
  State<SeeAllListPage> createState() => _SeeAllListPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PropertyListBloc>(),
      child: this,
    );
  }
}

class _SeeAllListPageState extends State<SeeAllListPage> {
  @override
  void initState() {
    super.initState();

    // Load the specific section if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _loadSection());
  }

  void _loadSection() {
    final bloc = context.read<PropertyListBloc>();
    switch (widget.section) {
      case PropertySection.all:
        bloc.add(const GetAllProperties());
        break;
      case PropertySection.recommended:
        bloc.add(const GetRecommendedProperties());
        break;
      case PropertySection.nearby:
        // bloc.add(GetNearbyProperties(latitude: lat, longitude: lng));
        break;

      case .my:
        context.read<PropertyListBloc>().add(
          GetMyProperties(
            userId: (context.read<AuthCubit>().state as Authenticated)
                .currentUser!
                .uid,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: SafeArea(
        child: BlocBuilder<PropertyListBloc, PropertyListState>(
          builder: (context, state) {
            // Handle loading for this specific section
            if (state is PropertyListLoading &&
                state.section == widget.section) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle error for this specific section
            if (state is PropertyListFailure &&
                state.section == widget.section) {
              return HandleErrorState(
                message: state.message,
                retry: _loadSection,
              );
            }

            // Handle loaded state - extract the right property list
            if (state is PropertyListLoaded) {
              final properties = _getPropertiesForSection(state);

              if (properties == null) {
                return const Center(child: Text('Loading...'));
              }

              if (properties.isEmpty) {
                return const Center(child: Text('No properties available'));
              }

              return PropertyList(propertyList: properties, showAll: true);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Extract the appropriate property list based on section
  List<Property>? _getPropertiesForSection(PropertyListLoaded state) {
    return switch (widget.section) {
      PropertySection.all => state.allProperties,
      PropertySection.recommended => state.recommendedProperties,
      PropertySection.nearby => state.nearbyProperties,
      .my => state.myProperties,
    };
  }
}
