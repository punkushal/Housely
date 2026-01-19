import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';

class PriceDetails extends StatelessWidget {
  const PriceDetails({
    super.key,
    required this.price,
    required this.propertyType,
  });
  final double price;
  final String propertyType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.spacing4(context),
      children: [
        const HeadingLabel(label: "Price Details"),
        SizedBox(height: ResponsiveDimensions.spacing4(context)),
        BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: .start,
              spacing: ResponsiveDimensions.spacing8(context),
              children: [
                _buildInfo(
                  context,
                  label: "Period Time",
                  price: state.bookingType.name == 'monthly'
                      ? '${state.totalDuration} Month'
                      : '${state.totalDuration} Day',
                ),
                _buildInfo(
                  context,
                  label:
                      "${propertyType == 'house' ? 'Monthly' : 'Per night'} payment",
                  price: "\$$price",
                ),
                _buildInfo(
                  context,
                  label: "Total",
                  price: "\$${state.totalPrice}",
                  isTotal: true,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfo(
    BuildContext context, {
    required String label,
    required String price,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyMedium(
            context,
            color: isTotal ? AppColors.textPrimary : AppColors.textHint,
            fontSize: 12,
          ),
        ),

        Text(
          price,
          style: isTotal
              ? AppTextStyle.bodySemiBold(context, color: AppColors.primary)
              : AppTextStyle.bodyRegular(context),
        ),
      ],
    );
  }
}
