import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveDimensions.getHeight(context, 104),
      padding: ResponsiveDimensions.paddingAll12(context),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          //TODO: later add image in it
          CircleAvatar(
            radius: ResponsiveDimensions.radiusXLarge(context, size: 40),
          ),
          ResponsiveDimensions.gapW12(context),
          Column(
            crossAxisAlignment: .start,
            children: [
              // reviewer name
              Text("Theresa Webb", style: AppTextStyle.bodySemiBold(context)),

              // review text
              SizedBox(
                width: ResponsiveDimensions.getSize(context, 134),
                child: Text(
                  "This is my review and i have to say it..",
                  style: AppTextStyle.bodyRegular(
                    context,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),

          // rating
          SizedBox(
            height: ResponsiveDimensions.getHeight(context, 18),
            width: ResponsiveDimensions.getSize(context, 60),
            child: ListView.builder(
              //TODO: later dynamic content will be added
              scrollDirection: .horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return SvgPicture.asset(ImageConstant.starIcon);
              },
            ),
          ),
        ],
      ),
    );
  }
}
