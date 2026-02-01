import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class PaymentHistoryCard extends StatelessWidget {
  const PaymentHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      height: ResponsiveDimensions.getSize(context, 68),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: ResponsiveDimensions.paddingAll8(context),
          height: ResponsiveDimensions.getSize(context, 34),
          width: ResponsiveDimensions.getSize(context, 34),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(ImageConstant.hospitalIcon, fit: .scaleDown),
        ),
        title: Text(
          "123 Maple St, NY",
          style: AppTextStyle.bodySemiBold(context, fontSize: 12),
        ),

        subtitle: Text(
          "Rent",
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),

        trailing: Column(
          mainAxisSize: .min,
          children: [
            Text(
              "Rs 24,000",
              style: AppTextStyle.bodySemiBold(
                context,
                fontSize: 12,
                color: AppColors.primaryPressed,
              ),
            ),
            Text(
              "Oct 12, 2025",
              style: AppTextStyle.bodyRegular(
                context,
                color: AppColors.textHint,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
