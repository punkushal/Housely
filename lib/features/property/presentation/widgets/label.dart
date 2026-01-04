import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';

class Label extends StatelessWidget {
  const Label({super.key, required this.label});

  /// label text
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyle.bodySemiBold(context));
  }
}
