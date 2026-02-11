import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';

import '../../../../core/extensions/context_extension.dart';

class RatingSection extends StatelessWidget {
  const RatingSection({super.key});

  // no rating selected
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: context.sp8,
      children: [
        const HeadingLabel(label: 'How was your experience?'),
        _buildRatingStars(context),
      ],
    );
  }

  Widget _buildRatingStars(BuildContext context) {
    int currentIndex = -1;
    return Row(
      spacing: context.sp8,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            currentIndex = currentIndex == index ? -1 : index;
            context.read<ReviewBloc>().add(AddRatings(currentIndex));
          },
          child: BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              return SvgPicture.asset(
                ImageConstant.starIcon,
                height: context.sp24,
                width: context.sp24,
                colorFilter: ColorFilter.mode(
                  (state.ratings == null || state.ratings! < 0)
                      ? AppColors.border
                      : index <= state.ratings!
                      ? AppColors.ratingStrong
                      : AppColors.border,
                  .srcIn,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
