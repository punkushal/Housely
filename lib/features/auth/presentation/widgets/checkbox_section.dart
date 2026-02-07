import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CheckboxSection extends StatelessWidget {
  const CheckboxSection({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    this.hasHighlightText = false,
  });

  /// check box side label text
  final String? labelText;

  /// Check box actual value
  final bool value;

  /// Check box on changed function
  final void Function(bool? value)? onChanged;

  /// To check whether the text content has highlighted parts
  /// by default false
  final bool hasHighlightText;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: ResponsiveDimensions.spacing8(context),
      children: [
        SizedBox(
          width: ResponsiveDimensions.getSize(context, 16),
          height: ResponsiveDimensions.getHeight(context, 16),
          child: Checkbox(value: value, onChanged: onChanged),
        ),
        hasHighlightText
            ? RichText(
                text: TextSpan(
                  text: 'Agree with ',
                  style: AppTextStyle.bodyRegular(context, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'terms ',
                      style: AppTextStyle.bodySemiBold(context),
                    ),
                    TextSpan(text: 'and '),
                    TextSpan(
                      text: 'privacy',
                      style: AppTextStyle.bodySemiBold(context),
                    ),
                  ],
                ),
              )
            : Text(
                labelText!,
                style: AppTextStyle.bodyRegular(context, fontSize: 14),
              ),
      ],
    );
  }
}
