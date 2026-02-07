import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class LocationDetail extends StatelessWidget {
  const LocationDetail({super.key, required this.address});
  final String address;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDimensions.paddingSymmetric(context, horizontal: 20),
      padding: ResponsiveDimensions.paddingAll16(context),
      width: ResponsiveDimensions.getSize(context, 327),
      height: ResponsiveDimensions.getHeight(context, 149),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveDimensions.radiusSmall(context, size: 10),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: ResponsiveDimensions.getHeight(context, 12),
        children: [
          Text(
            'Location Details',
            style: AppTextStyle.bodySemiBold(
              context,
              fontSize: 20,
              lineHeight: 26,
            ),
          ),
          Row(
            spacing: ResponsiveDimensions.getSize(context, 12),
            children: [
              Container(
                width: ResponsiveDimensions.getSize(context, 44),
                height: ResponsiveDimensions.getHeight(context, 44),
                decoration: BoxDecoration(
                  shape: .circle,
                  color: Color(0xFFF4EBFF),
                ),
                child: Icon(Icons.location_on_outlined),
              ),

              SizedBox(
                width: ResponsiveDimensions.getSize(context, 230),
                child: Text(
                  address,
                  overflow: .ellipsis,
                  style: AppTextStyle.bodyRegular(
                    context,
                    fontSize: 14,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
