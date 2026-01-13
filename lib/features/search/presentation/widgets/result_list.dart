import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class ResultList extends StatelessWidget {
  const ResultList({super.key, required this.propertyList});
  final List<Property> propertyList;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: propertyList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(context, bottom: 16),
            child: GestureDetector(
              onTap: () {
                context.router.push(DetailRoute(property: propertyList[index]));
              },
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  index == 0
                      ? Padding(
                          padding: ResponsiveDimensions.paddingOnly(
                            context,
                            bottom: 16,
                          ),
                          child: HeadingLabel(label: "Result"),
                        )
                      : SizedBox.shrink(),
                  Row(
                    crossAxisAlignment: .start,
                    spacing: ResponsiveDimensions.spacing12(context),
                    children: [
                      SvgPicture.asset(
                        ImageConstant.locationIcon,
                        width: ResponsiveDimensions.spacing24(context),
                        height: ResponsiveDimensions.spacing24(context),
                        colorFilter: ColorFilter.mode(
                          AppColors.textPrimary,
                          .srcIn,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          // property name
                          Text(
                            propertyList[index].name.capitalize,
                            style: AppTextStyle.bodySemiBold(
                              context,
                              fontSize: 12,
                            ),
                          ),

                          // location
                          Text(
                            propertyList[index].location.address.capitalize,
                            style: AppTextStyle.bodyRegular(
                              context,
                              color: AppColors.textHint,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveDimensions.spacing12(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // divider
                  Padding(
                    padding: ResponsiveDimensions.paddingOnly(
                      context,
                      left: 36,
                    ),
                    child: SizedBox(
                      width: .infinity,
                      child: Divider(color: AppColors.textHint),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
