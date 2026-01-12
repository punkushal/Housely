import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues values = RangeValues(10, 100);
  double startValue = 10;
  double lastValue = 1000;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.spacing8(context),
      children: [
        HeadingLabel(label: "Price Range"),
        SizedBox(height: ResponsiveDimensions.spacing8(context)),
        RangeSlider(
          values: values,
          min: 10,
          max: 1000,
          inactiveColor: AppColors.divider,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              values = value;
            });
          },
          padding: .zero,
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "\$${values.start.round()}",
              style: AppTextStyle.bodySemiBold(
                context,
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            Text(
              "\$${values.end.round()}",
              style: AppTextStyle.bodySemiBold(
                context,
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
