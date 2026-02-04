import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

import 'custom_button.dart';

class HandleErrorState extends StatelessWidget {
  const HandleErrorState({
    super.key,
    required this.message,
    required this.retry,
  });

  /// Error message
  final String message;

  /// Retry method
  final void Function() retry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: ResponsiveDimensions.spacing16(context),
        mainAxisAlignment: .center,
        children: [
          Text(message),
          CustomButton(onTap: retry, buttonLabel: 'Retry'),
        ],
      ),
    );
  }
}
