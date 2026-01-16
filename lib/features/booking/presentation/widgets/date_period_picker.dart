import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:housely/features/booking/presentation/widgets/smart_property_calendar.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';

class DatePeriodPicker extends StatelessWidget {
  const DatePeriodPicker({
    super.key,
    required this.propertyType,
    required this.price,
  });
  final String propertyType;
  final double price;
  void showCalender(BuildContext context) {
    final calendarCubit = context.read<CalendarCubit>();
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: BlocProvider.value(
          value: calendarCubit,
          child: SmartPropertyCalendar(
            propertyType: propertyType,
            price: price,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const HeadingLabel(label: "Period"),
        ListTile(
          onTap: () {
            showCalender(context);
          },
          contentPadding: .zero,
          leading: SvgPicture.asset(
            ImageConstant.calenderIcon,
            fit: .scaleDown,
            height: ResponsiveDimensions.getSize(context, 36),
            width: ResponsiveDimensions.getSize(context, 36),
          ),
          title: BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, state) {
              final hasData = state.hasSelectedDate;
              return Text(
                hasData ? state.formattedDateText : 'Select date',
                style: AppTextStyle.bodyMedium(context),
              );
            },
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.border),
        ),

        Divider(color: AppColors.divider),
        SizedBox(height: ResponsiveDimensions.spacing12(context)),
        Text(
          "Make sure to check your date before making any sort of payments",
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),
      ],
    );
  }
}
