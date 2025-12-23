import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/onboarding/presentation/widgets/skip_button.dart';

@RoutePage()
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [SkipButton()]),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: ResponsiveDimensions.spacing16(context),
            children: [
              SizedBox(height: ResponsiveDimensions.getHeight(context, 40)),
              Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 38,
                ),
                child: Column(
                  spacing: ResponsiveDimensions.spacing16(context),
                  children: [
                    //location image
                    Image.asset(ImageConstant.searchLocationImg),

                    SizedBox(
                      height: ResponsiveDimensions.getHeight(context, 14),
                    ),
                    // welcome message
                    Text(
                      "Hi, Nice to meet you !",
                      style: AppTextStyle.bodySemiBold(
                        context,
                        fontSize: 20,
                        lineHeight: 26,
                      ),
                    ),

                    // info message
                    Text(
                      "Choose your location to find property around you",
                      style: AppTextStyle.bodyRegular(
                        context,
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                      textAlign: .center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.getHeight(context, 60)),
              // current location button
              CustomButton(
                onTap: () {},
                buttonLabel: "Use current location",
                horizontal: 24,
              ),
              CustomButton(
                onTap: () {},
                buttonLabel: "Select it manually",
                horizontal: 24,
                isOutlined: true,
                textColor: AppColors.primary,
              ),
              SizedBox(height: ResponsiveDimensions.getHeight(context, 48)),
            ],
          ),
        ),
      ),
    );
  }
}
