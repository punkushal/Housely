import 'package:flutter/material.dart';

class DropShadow extends StatelessWidget {
  const DropShadow({super.key, this.boxShadow, this.child});

  /// list of box shadows
  final List<BoxShadow>? boxShadow;

  /// widget
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: child,
    );
  }
}
