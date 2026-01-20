import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/utils/calculate_duration.dart';
import 'package:intl/intl.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial());

  /// Call this when initializing the page to set the mode
  void initBookingType(String propertyType) {
    final isHouse = propertyType.toLowerCase() == 'house';
    emit(
      state.copyWith(
        bookingType: isHouse ? BookingType.monthly : BookingType.nightly,
      ),
    );
  }

  /// Logic for "House" (Monthly selection)
  void selectMonths(List<DateTime> months, double monthlyPrice) {
    // Calculate duration (simple count of selected months)
    final duration = months.length;

    // Calculate price
    final total = duration * monthlyPrice;

    emit(
      state.copyWith(
        selectedMonths: months,
        totalDuration: duration,
        totalPrice: total,
        // Clear nightly data to avoid confusion
        startDate: null,
        endDate: null,
      ),
    );
  }

  /// Logic for "Villa/Apartment" (Nightly selection)
  void selectDateRange(DateTime? start, DateTime? end, double pricePerNight) {
    if (start == null || end == null) {
      // Incomplete selection
      emit(
        state.copyWith(
          startDate: start,
          endDate: end,
          totalPrice: 0.0,
          totalDuration: 0,
        ),
      );
      return;
    }

    // Calculate nights (Difference in days)
    // If start and end are same day, it counts as 1 day
    int nights = calculateDuration(start: start, end: end);
    if (nights == 0) nights = 1; // Minimum 1 night charge

    // Calculate price
    final total = nights * pricePerNight;

    emit(
      state.copyWith(
        startDate: start,
        endDate: end,
        totalDuration: nights,
        totalPrice: total,
        // Clear monthly data
        selectedMonths: [],
      ),
    );
  }

  void setExistingBookingDates({
    required BookingType type,
    DateTime? start,
    DateTime? end,
    List<DateTime> months = const [],
    required double amount,
  }) {
    emit(
      state.copyWith(
        bookingType: type,
        startDate: start,
        endDate: end,
        selectedMonths: months,
        totalPrice: amount,
        totalDuration: calculateDuration(
          selectedMonths: months,
          start: start,
          end: end,
        ),
      ),
    );
  }

  void reset() {
    emit(CalendarState.initial());
  }
}
