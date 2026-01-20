import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
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

  @override
  Widget build(BuildContext context) {
    final bool isHouse = propertyType.toLowerCase() == 'house';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Display the selection
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
            ),
            child: BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                return Text(
                  state.formattedDateText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
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
                cubit.selectDateRange(range.startDate, range.endDate, price);
              }
            },
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

          SizedBox(height: ResponsiveDimensions.spacing20(context)),
        ],
      ),
    );
  }
}
