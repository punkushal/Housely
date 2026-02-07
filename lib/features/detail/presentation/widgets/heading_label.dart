import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';

class HeadingLabel extends StatelessWidget {
  const HeadingLabel({super.key, required this.label});

  /// label text
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyle.bodySemiBold(context, fontSize: 16, lineHeight: 24),
    );
  }
}
