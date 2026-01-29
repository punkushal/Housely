import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/review/domain/entity/review.dart';

@RoutePage()
class ReviewDetailPage extends StatelessWidget {
  const ReviewDetailPage({
    super.key,
    required this.review,
    required this.property,
  });
  final Review review;
  final Property property;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated &&
                  state.currentUser!.uid == review.userId) {
                return IconButton(
                  onPressed: () {
                    context.router.push(
                      AddReviewRoute(property: property, existedReview: review),
                    );
                  },
                  icon: Icon(Icons.edit),
                );
              }

              return SizedBox.shrink();
            },
          ),
          SizedBox(width: ResponsiveDimensions.spacing8(context)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: ResponsiveDimensions.spacing16(context),
              children: [
                CustomCacheContainer(
                  imageUrl: property.media.coverImage['url'],
                  width: .infinity,
                  height: ResponsiveDimensions.getSize(context, 180),
                ),
                Text(
                  property.name,
                  style: AppTextStyle.headingSemiBold(
                    context,
                    fontSize: 20,
                    lineHeight: 28,
                  ),
                ),

                // reviewer section
                Row(
                  spacing: ResponsiveDimensions.spacing8(context),
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.divider,
                      child: SvgPicture.asset(ImageConstant.personIcon),
                    ),
                    Text(
                      review.userName,
                      style: AppTextStyle.bodySemiBold(context),
                    ),
                  ],
                ),

                // review comment
                Text(review.comment),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
