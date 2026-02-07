import 'package:flutter/widgets.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class NoBookingMessage extends StatelessWidget {
  const NoBookingMessage(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 34),
      child: Column(
        mainAxisAlignment: .center,
        spacing: ResponsiveDimensions.spacing12(context),
        children: [
          Image.asset(
            ImageConstant.noBookingImg,
            width: ResponsiveDimensions.getSize(context, 276),
            height: ResponsiveDimensions.getSize(context, 224),
            fit: .cover,
          ),

          Text(
            'You have no $label booking',
            style: AppTextStyle.headingSemiBold(
              context,
              fontSize: 20,
              lineHeight: 26,
            ),
            textAlign: .center,
          ),

          label == 'pending'
              ? RichText(
                  textAlign: .center,
                  text: TextSpan(
                    style: AppTextStyle.bodyRegular(
                      context,
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    text: "Are you looking for a ",
                    children: [
                      TextSpan(
                        text: "completed ",
                        style: AppTextStyle.bodyRegular(
                          context,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(text: "or "),
                      TextSpan(
                        text: "cancelled ",
                        style: AppTextStyle.bodyRegular(
                          context,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(text: "booking? "),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
