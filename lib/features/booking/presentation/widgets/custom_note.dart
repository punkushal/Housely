import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/extensions/context_extension.dart';

class CustomNote extends StatelessWidget {
  const CustomNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.responsive(120),
      padding: .symmetric(horizontal: context.sp8, vertical: context.sp4),
      decoration: BoxDecoration(
        borderRadius: .circular(context.sp8),
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
