import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingOnly(context, bottom: 16),
      child: Column(
        spacing: ResponsiveDimensions.spacing16(context),
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: ResponsiveDimensions.spacing12(context),
            children: [
              // profile image
              CircleAvatar(radius: ResponsiveDimensions.getSize(context, 32)),
              Row(
                crossAxisAlignment: .start,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(height: ResponsiveDimensions.spacing4(context)),
                      // name
                      Text('Angela', style: AppTextStyle.bodySemiBold(context)),

                      // last message
                      SizedBox(
                        width: ResponsiveDimensions.getSize(context, 170),
                        child: Text(
                          'Thank your for information that you sent me last weekend',
                          overflow: .ellipsis,
                          style: AppTextStyle.bodyRegular(
                            context,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: ResponsiveDimensions.paddingOnly(context, top: 4),
                    child: Text(
                      '1:22 AM',
                      style: AppTextStyle.labelMedium(
                        context,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Padding(
            padding: ResponsiveDimensions.paddingOnly(context, left: 74),
            child: Divider(color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}
