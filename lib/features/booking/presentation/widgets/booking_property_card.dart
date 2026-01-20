import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class BookingPropertyCard extends StatelessWidget {
  const BookingPropertyCard({super.key, required this.property});
  final Property property;
  @override
  Widget build(BuildContext context) {
    final isMonth =
        property.type.name.toLowerCase() ==
        PropertyType.house.name.toLowerCase();
    return Container(
      height: ResponsiveDimensions.getSize(context, 94),
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 8,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
      ),
      child: Row(
        spacing: ResponsiveDimensions.spacing8(context),
        crossAxisAlignment: .end,
        children: [
          // cover image
          ClipRRect(
            borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
            child: CustomCacheContainer(
              imageUrl: property.media.coverImage['url'],
              width: 88,
              height: 75,
            ),
          ),

          // property details
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: ResponsiveDimensions.getSize(context, 150),
                child: Text(
                  property.name,
                  style: AppTextStyle.bodySemiBold(context),
                  overflow: .ellipsis,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageConstant.locationIcon,
                    colorFilter: ColorFilter.mode(AppColors.textHint, .srcIn),
                    fit: .scaleDown,
                  ),

                  SizedBox(
                    width: ResponsiveDimensions.getSize(context, 140),
                    child: Text(property.location.address, overflow: .ellipsis),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveDimensions.spacing12(context)),
              Text(
                "\$${property.price.amount}/${isMonth ? 'month' : 'night'}",
                style: AppTextStyle.labelSemiBold(
                  context,
                  fontSize: 10,
                  lineHeight: 14,
                ),
              ),
            ],
          ),

          // rating
          Row(
            children: [
              SvgPicture.asset(ImageConstant.starIcon),
              //TODO: later actual rating will be added
              Text('4.8', style: AppTextStyle.labelBold(context, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
