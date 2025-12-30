import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/big_card.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  void toggleFavorite(BuildContext context) {
    context.read<FavoriteToggleCubit>().toggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: SizedBox(
        height: ResponsiveDimensions.getHeight(context, 164),
        child: ListView.builder(
          scrollDirection: .horizontal,
          itemCount: 3, // later actual data length will be passed on
          itemBuilder: (context, index) {
            return Padding(
              padding: ResponsiveDimensions.paddingOnly(context, right: 16),
              child: BigCard(
                price: 330,
                imagePath: ImageConstant.firstVilla,
                propertyName: "Ayana Homestay",
                location: "Imogiri, Yogyakarta",
                onFavorite: () {
                  // later implement add to favorite list
                  toggleFavorite(context);
                },
                navigateTo: () => context.router.push(DetailRoute()),
              ),
            );
          },
        ),
      ),
    );
  }
}
