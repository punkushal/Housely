import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  });

  /// [TextEditingController] controller
  final TextEditingController? controller;

  /// hint text
  final String? hintText;

  /// hint style
  final TextStyle? hintStyle;

  /// keyboard type
  final TextInputType? keyboardType;

  /// prefix icon
  final Widget? prefixIcon;

  /// suffix icon
  final Widget? suffixIcon;

  /// obscure the text, by default false
  final bool obscureText;

  /// validator function
  final String? Function(String? value)? validator;

  /// on changed function
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
