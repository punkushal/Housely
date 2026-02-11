import 'package:flutter/material.dart';
import 'package:housely/core/responsive/breakpoints.dart';

extension Responsive on BuildContext {
  // Get Core Dimensions efficiently
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  // Calculate scale factors
  double get _scaleW => width / Breakpoints.smallPhone;

  // The "Smart" Scale
  // Use this for general sizing. It prevents things from getting too huge on tablets.
  // We cap the scaling at a reasonable max (e.g., 1.5x) so buttons don't become massive.
  double responsive(double size) {
    double scale = _scaleW;
    // Optional: Lock scaling on Tablet/Desktop to avoid "blown up" mobile UI
    if (width > 600) scale = 600 / Breakpoints.smallPhone;
    return size * scale;
  }

  // Font Scaling (Crucial!)
  // Use textScaleFactor to respect user accessibility settings
  double responsiveFont(double size) {
    // Limits how huge the text can get if the user has massive font settings
    // This prevents UI breaking while still being accessible
    double textScale = MediaQuery.textScalerOf(this).scale(size);
    return textScale;
  }
}

extension Spacing on BuildContext {
  // Spacing (paddings, margins)
  double get sp4 => responsive(4);
  double get sp8 => responsive(8);
  double get sp12 => responsive(12);
  double get sp16 => responsive(16);
  double get sp20 => responsive(20);
  double get sp24 => responsive(24);
  double get sp32 => responsive(32);
  double get sp40 => responsive(40);
  double get sp48 => responsive(48);
}
