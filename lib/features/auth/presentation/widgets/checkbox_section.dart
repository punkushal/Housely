import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/extensions/context_extension.dart';

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
      spacing: context.sp8,
      children: [
        SizedBox(width: context.responsive(2)),
        SizedBox(
          width: context.sp12,
          height: context.sp12,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            visualDensity: .compact,
          ),
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
