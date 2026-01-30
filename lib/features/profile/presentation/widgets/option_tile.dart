import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });
  final String label;
  final String iconPath;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(AppColors.primaryPressed, .srcIn),
      ),
      title: Text(label),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.divider),
    );
  }
}
