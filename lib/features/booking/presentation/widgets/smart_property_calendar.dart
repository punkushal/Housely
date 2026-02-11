import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SmartPropertyCalendar extends StatelessWidget {
  final String propertyType;
  final double price;
  const SmartPropertyCalendar({
    super.key,
    required this.propertyType,
    required this.price,
  });

  /// Check if a date/month is already booked by someone else
  bool _isDateBlocked(DateTime date, CalendarState state) {
    final blockedBookings = state.blockedBookings;
    final isHouse = propertyType.toLowerCase() == 'house';

    for (final booking in blockedBookings) {
      if (isHouse) {
        // MONTHLY BOOKING MODE (House)
        // Check if this month matches any selected months in existing bookings
        if (booking.selectedMonths.isNotEmpty) {
          final monthBlocked = booking.selectedMonths.any((blockedMonth) {
            return date.year == blockedMonth.year &&
                date.month == blockedMonth.month;
          });
          if (monthBlocked) return true;
        }
      } else {
        // NIGHTLY BOOKING MODE (Villa/Apartment)
        // Check if this date falls within an existing booking's date range
        if (booking.startDate != null && booking.endDate != null) {
          final startDate = DateTime(
            booking.startDate!.year,
            booking.startDate!.month,
            booking.startDate!.day,
          );
          final endDate = DateTime(
            booking.endDate!.year,
            booking.endDate!.month,
            booking.endDate!.day,
          );
          final checkDate = DateTime(date.year, date.month, date.day);

          // Date is blocked if it's >= startDate AND <= endDate
          if (!checkDate.isBefore(startDate) && !checkDate.isAfter(endDate)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isHouse = propertyType.toLowerCase() == 'house';

    return SingleChildScrollView(
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          return Column(
            children: [
              // Display the selection
              Container(
                padding: .all(context.sp16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: .circular(context.sp12),
                ),
                child: Text(
                  state.formattedDateText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SfDateRangePicker(
                // If House: Show 'Year' view (user sees months: Jan, Feb...)
                // If Other: Show 'Month' view (user sees days: 1, 2, 3...)
                view: isHouse
                    ? DateRangePickerView.year
                    : DateRangePickerView.month,

                // TOGGLE NAVIGATION:
                // If House: Lock navigation so clicking "Jan" selects it instead of opening it
                allowViewNavigation: !isHouse,

                // TOGGLE SELECTION MODE:
                // If House: 'Multiple' allows picking "Jan" AND "Feb"
                // If Other: 'Range' allows picking "Jan 1st" TO "Jan 5th"
                selectionMode: isHouse
                    ? DateRangePickerSelectionMode.multiple
                    : DateRangePickerSelectionMode.range,

                // Disable already-booked dates
                selectableDayPredicate: (DateTime date) {
                  // Return false to disable the date
                  return !_isDateBlocked(date, state);
                },

                // Handle the logic for each mode
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  final cubit = context.read<CalendarCubit>();

                  if (isHouse) {
                    // args.value is List<DateTime> (Selected Months)
                    final List<DateTime> months = args.value as List<DateTime>;
                    cubit.selectMonths(months, price);
                  } else {
                    // args.value is PickerDateRange (Start & End Date)
                    final PickerDateRange range = args.value as PickerDateRange;
                    cubit.selectDateRange(
                      range.startDate,
                      range.endDate,
                      price,
                    );
                  }
                },
                monthCellStyle: DateRangePickerMonthCellStyle(
                  blackoutDateTextStyle: TextStyle(
                    color: AppColors.textHint.withValues(alpha: 0.4),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                enablePastDates: false,
                backgroundColor: Color(0xFFFAFAFA),
                todayHighlightColor: AppColors.primary,
                selectionColor: isHouse ? Colors.green : Colors.blue,
                startRangeSelectionColor: AppColors.primary,
                endRangeSelectionColor: AppColors.primary,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: AppColors.background,
                ),
              ),

              BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  bool hasDate = state.hasSelectedDate;
                  return CustomButton(
                    onTap: hasDate
                        ? () {
                            context.pop();
                          }
                        : null,
                    buttonLabel: TextConstants.save,
                  );
                },
              ),

              SizedBox(height: context.sp20),
            ],
          );
        },
      ),
    );
  }
}
