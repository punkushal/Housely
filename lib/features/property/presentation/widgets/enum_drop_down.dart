import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/extensions/string_extension.dart';

class EnumDropdown<T extends Enum> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final String? Function(T? value)? validator;
  const EnumDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      hint: Text(
        hintText,
        style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
      ),
      icon: const SizedBox.shrink(),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.name.capitalize),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
