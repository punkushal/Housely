import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/features/detail/presentation/widgets/review_list.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../property/presentation/bloc/crud/property_crud_bloc.dart';

@RoutePage()
class AllReviewListPage extends StatefulWidget {
  const AllReviewListPage({
    super.key,
    required this.allReviews,
    required this.property,
  });
  final List<Review> allReviews;
  final Property property;

  @override
  State<AllReviewListPage> createState() => _AllReviewListPageState();
}

class _AllReviewListPageState extends State<AllReviewListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ReviewBloc>().add(
        GetAllReviews(propertyId: widget.property.id!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Reviews")),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          final reviews = state.allReviews.isNotEmpty
              ? state.allReviews
              : widget.allReviews;

          if (state.status == ReviewStatus.loading &&
              state.allReviews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ReviewList(
            allReviewsList: reviews,
            showAll: true,
            property: widget.property,
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () async {
              final result = await context.router.push(
                AddReviewRoute(property: widget.property),
              );

              if (result == true && context.mounted) {
                context.read<PropertyCrudBloc>().add(
                  RefreshPropertyEvent(widget.property.id!),
                );
                context.read<ReviewBloc>().add(
                  GetAllReviews(propertyId: widget.property.id!),
                );

                context.read<PropertyListBloc>().add(GetAllProperties());
                context.read<PropertyListBloc>().add(
                  GetMyProperties(
                    userId: (context.read<AuthCubit>().state as Authenticated)
                        .currentUser!
                        .uid,
                  ),
                );
              }
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
