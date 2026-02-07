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

import '../bloc/booking_bloc.dart';

class DatePeriodPicker extends StatelessWidget {
  const DatePeriodPicker({
    super.key,
    required this.propertyType,
    required this.price,
    required this.propertyId,
  });
  final String propertyType;
  final String propertyId;
  final double price;
  void showCalender(BuildContext context) {
    final calendarCubit = context.read<CalendarCubit>();
    final bookingBloc = context.read<BookingBloc>();

    bookingBloc.add(LoadPropertyBookingsEvent(propertyId));

    // If bookings were already loaded before the bottom sheet is shown,
    // set them immediately to avoid a race where the listener is not yet attached.
    final currentBookingState = bookingBloc.state;
    if (currentBookingState is PropertyBookingsLoaded) {
      calendarCubit.setBlockedBookings(currentBookingState.bookings);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: calendarCubit),
            BlocProvider.value(value: bookingBloc),
          ],
          child: BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              // Once the property bookings are loaded, store them in the calendar cubit
              if (state is PropertyBookingsLoaded) {
                calendarCubit.setBlockedBookings(state.bookings);
              }
            },
            child: SmartPropertyCalendar(
              propertyType: propertyType,
              price: price,
            ),
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
