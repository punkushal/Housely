import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    super.key,
    required this.label,
    this.number,
    this.infoText = "For Rent",
  });

  /// label text
  final String label;

  /// label text
  final String infoText;

  /// count value
  final int? number;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyRegular(
            context,
            lineHeight: 14,
            color: AppColors.textHint,
          ),
        ),

        Text(
          number != null ? number.toString() : infoText,
          style: AppTextStyle.labelSemiBold(
            context,
            fontSize: 12,
            lineHeight: 14,
          ),
        ),
      ],
    );
  }
}
