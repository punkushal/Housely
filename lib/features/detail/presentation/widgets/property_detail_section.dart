import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/detail/presentation/widgets/contact_container.dart';
import 'package:housely/features/detail/presentation/widgets/facility_list.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/detail/presentation/widgets/icon_info_container.dart';
import 'package:housely/features/detail/presentation/widgets/info_container.dart';
import 'package:housely/features/detail/presentation/widgets/read_more_text.dart';
import 'package:housely/features/detail/presentation/widgets/review_list.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';

// TODO: later value will be dynamic and access through variables
class PropertyDetailSection extends StatelessWidget {
  const PropertyDetailSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: ResponsiveDimensions.getHeight(context, 16),
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .start,
          children: [
            // property name and location
            Column(
              crossAxisAlignment: .start,
              spacing: ResponsiveDimensions.getHeight(context, 4),
              children: [
                // property title
                Text(
                  "House of Mormon",
                  style: AppTextStyle.bodySemiBold(
                    context,
                    fontSize: 20,
                    lineHeight: 26,
                  ),
                ),

                // location
                Row(
                  spacing: ResponsiveDimensions.spacing4(context),
                  children: [
                    SvgPicture.asset(
                      ImageConstant.locationIcon,
                      width: ResponsiveDimensions.getSize(context, 24),
                      height: ResponsiveDimensions.getHeight(context, 24),
                      colorFilter: ColorFilter.mode(AppColors.textHint, .srcIn),
                    ),

                    Text(
                      'Denspasar, Bali',
                      style: AppTextStyle.bodyRegular(
                        context,
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // price
            RichText(
              text: TextSpan(
                text: "\$310",
                style: AppTextStyle.labelBold(
                  context,
                  lineHeight: 18,
                  fontSize: 14,
                  color: AppColors.primaryPressed,
                ),
                children: [
                  TextSpan(
                    text: "/month",
                    style: AppTextStyle.bodyRegular(
                      context,
                      lineHeight: 14,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

        HeadingLabel(label: "Property Details"),

        // Property details
        Column(
          crossAxisAlignment: .start,
          spacing: ResponsiveDimensions.getHeight(context, 12),
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                IconInfoContainer(
                  label: "Bedrooms",
                  iconPath: ImageConstant.bedIcon,
                  number: 3,
                ),
                IconInfoContainer(
                  label: "Bathtub",
                  iconPath: ImageConstant.bathTubIcon,
                  number: 3,
                ),
                IconInfoContainer(
                  label: "Bedrooms",
                  iconPath: ImageConstant.areaIcon,
                  number: 1880,
                  isArea: true,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                InfoContainer(label: "Build", number: 2020),
                Spacer(),
                InfoContainer(label: "Parking", infoText: "1 Indoor"),

                SizedBox(width: ResponsiveDimensions.getSize(context, 67)),
                InfoContainer(label: "Status"),

                SizedBox(width: ResponsiveDimensions.getSize(context, 21)),
              ],
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

        // Description section
        HeadingLabel(label: "Description"),
        ReadMoreText(
          text:
              "This is a short description about this property. I hope you like this. It's surrounding is something that you might love it",
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),

        SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

        // owner section
        HeadingLabel(label: "Agent"),
        Row(
          spacing: ResponsiveDimensions.spacing16(context),
          children: [
            // TODO: later actual image will be placed
            CircleAvatar(
              radius: ResponsiveDimensions.radiusXLarge(context, size: 22),
              backgroundColor: Colors.grey,
            ),

            Column(
              crossAxisAlignment: .start,
              children: [
                // user name
                Text("Kushal Pun", style: AppTextStyle.bodySemiBold(context)),

                // user role
                Text(
                  "Owner",
                  style: AppTextStyle.bodyRegular(
                    context,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            Spacer(),
            // contact section
            Row(
              spacing: ResponsiveDimensions.spacing8(context),
              children: [
                ContactContainer(iconPath: ImageConstant.callIcon),
                ContactContainer(iconPath: ImageConstant.chatIcon),
              ],
            ),
          ],
        ),

        SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

        // location & facility
        HeadingLabel(label: "Location & Public Facilities"),

        FacilityList(),

        // map preview image
        GestureDetector(
          // TODO: later if agent or owner added their location then only this preview
          // vissible otherwise hidden
          onTap: () => context.router.push(LocationWrapper()),
          child: ClipRRect(
            borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
            child: Image.asset(
              ImageConstant.mapPreviewImg,
              fit: .cover,
              height: ResponsiveDimensions.getHeight(context, 142),
              width: .infinity,
            ),
          ),
        ),

        // Review section
        HeadingSection(title: "Reviews", onTapText: "See all"),

        ReviewList(),

        // rent button
        CustomButton(onTap: () {}, buttonLabel: TextConstants.rent),
      ],
    );
  }
}
