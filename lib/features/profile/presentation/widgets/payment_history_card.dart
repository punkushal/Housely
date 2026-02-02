import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class PaymentHistoryCard extends StatelessWidget {
  const PaymentHistoryCard({
    super.key,
    required this.booking,
    required this.property,
  });
  final Booking booking;
  final Property property;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 22,
        vertical: 12,
      ),
      width: .infinity,
      height: ResponsiveDimensions.getSize(context, 74),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: 8,
        ),
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
          property.name,
          overflow: .ellipsis,
          style: AppTextStyle.bodySemiBold(context, fontSize: 12),
        ),

        subtitle: Text(
          property.status.name,
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),

        trailing: Text(
          "Rs${booking.amount}",
          style: AppTextStyle.bodySemiBold(
            context,
            fontSize: 12,
            color: AppColors.primaryPressed,
          ),
        ),
      ),
    );
  }
}
