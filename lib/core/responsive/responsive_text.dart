import 'package:flutter/material.dart';
import 'package:housely/core/responsive/breakpoints.dart';

class ResponsiveText {
  ResponsiveText._();

  /// Get the responsive font size based on device width
  static double getSize(BuildContext ctx, {required double fontSize}) {
    double screenWidth = MediaQuery.widthOf(ctx);
    double scaleFactor = screenWidth / Breakpoints.smallPhone;
    return (fontSize * scaleFactor).clamp(fontSize * 0.8, fontSize * 1.4);
  }
}
