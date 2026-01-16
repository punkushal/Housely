import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CustomNote extends StatelessWidget {
  const CustomNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveDimensions.getSize(context, 120),
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
        border: Border.all(color: AppColors.border),
      ),
      child: RichText(
        textAlign: .justify,
        text: TextSpan(
          text: "*Note:\n",
          style: AppTextStyle.bodyMedium(context),
          children: [
            TextSpan(
              text:
                  "Please select your preferred booking dates first. "
                  "Before making any payment, send a booking request to the property owner. "
                  "Once the owner accepts your request, you can confirm your booking and proceed with the payment.",
              style: AppTextStyle.bodyRegular(
                context,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
