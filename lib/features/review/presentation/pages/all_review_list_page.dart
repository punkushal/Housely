import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/detail/presentation/widgets/review_list.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/bloc/crud/property_crud_bloc.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class AllReviewListPage extends StatelessWidget {
  const AllReviewListPage({
    super.key,
    required this.allReviews,
    required this.property,
    required this.crudBloc,
  });
  final List<Review> allReviews;
  final Property property;
  final PropertyCrudBloc crudBloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("All Reviews")),
            body: ReviewList(
              allReviewsList: allReviews,
              showAll: true,
              property: property,
            ),
          );
        },
      ),
    );
  }
}
