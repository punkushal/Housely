import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/read_more_text.dart';
import 'package:housely/features/review/domain/entity/review.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    this.isDetailView = false,
  });
  final Review review;
  final bool isDetailView;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDimensions.paddingAll12(context),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.divider,
            radius: ResponsiveDimensions.radiusXLarge(context, size: 40),
            child:
                review.userProfile !=
                    null //TODO: i need modify user profile to hold map instead or string
                ? Image.network(review.userProfile!)
                : SvgPicture.asset(ImageConstant.personIcon, fit: .scaleDown),
          ),
          ResponsiveDimensions.gapW12(context),
          Column(
            crossAxisAlignment: .start,
            children: [
              // reviewer name
              Text(review.userName, style: AppTextStyle.bodySemiBold(context)),

              // review text
              SizedBox(
                width: ResponsiveDimensions.getSize(context, 134),
                child: isDetailView
                    ? ReadMoreText(
                        text: review.comment,
                        trimlines: 3,
                        style: AppTextStyle.bodyRegular(
                          context,
                          color: AppColors.textHint,
                        ),
                      )
                    : Text(
                        review.comment,
                        style: AppTextStyle.bodyRegular(
                          context,
                          color: AppColors.textHint,
                        ),
                        maxLines: 2,
                        overflow: .ellipsis,
                      ),
              ),
            ],
          ),

          // rating
          SizedBox(
            height: ResponsiveDimensions.getHeight(context, 18),
            width: ResponsiveDimensions.getSize(context, 60),
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SvgPicture.asset(
                  ImageConstant.starIcon,
                  colorFilter: ColorFilter.mode(
                    index <= (review.rating - 1)
                        ? AppColors.ratingStrong
                        : AppColors.border,
                    .srcIn,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
