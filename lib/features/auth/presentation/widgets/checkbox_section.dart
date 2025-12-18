import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CheckboxSection extends StatelessWidget {
  const CheckboxSection({super.key, required this.labelText});

  /// check box side label text
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: ResponsiveDimensions.spacing8(context),
      children: [
        SizedBox(
          width: ResponsiveDimensions.getSize(context, 16),
          height: ResponsiveDimensions.getHeight(context, 16),
          child: Checkbox(value: true, onChanged: (value) {}),
        ),
        Text(labelText, style: AppTextStyle.bodyRegular(context, fontSize: 14)),
      ],
    );
  }
}
