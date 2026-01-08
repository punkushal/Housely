import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';

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
    this.style,
    this.contentPadding,
    this.maxLines,
    this.readOnly = false,
    this.initialValue,
    this.fieldKey,
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

  /// text style for user input text
  final TextStyle? style;

  /// content padding
  final EdgeInsetsGeometry? contentPadding;

  /// max line for field
  final int? maxLines;

  /// enable read only
  final bool readOnly;

  /// initial value if controller not used
  final String? initialValue;

  /// field key
  final Key? fieldKey;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      initialValue: initialValue,
      readOnly: readOnly,
      style: style ?? AppTextStyle.bodyRegular(context, fontSize: 14),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
      ),
    );
  }
}
