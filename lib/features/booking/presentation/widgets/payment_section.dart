import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: context.sp16,
      children: [
        HeadingLabel(label: "Payments"),
        Row(
          spacing: context.sp16,
          children: [SvgPicture.asset(ImageConstant.creditIcon), Text('Esewa')],
        ),
      ],
    );
  }
}
