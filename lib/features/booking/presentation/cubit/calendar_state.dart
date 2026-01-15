// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_cubit.dart';

enum BookingType { monthly, nightly }

class CalendarState extends Equatable {
  final BookingType bookingType;

  // For House (Monthly)
  final List<DateTime> selectedMonths;

  // For Others (Nightly)
  final DateTime? startDate;
  final DateTime? endDate;

  // Calculation
  final double totalPrice;
  final int totalDuration; // Days for nightly, Months for monthly
  const CalendarState({
    this.bookingType = .nightly,
    this.selectedMonths = const [],
    this.startDate,
    this.endDate,
    this.totalPrice = 0.0,
    this.totalDuration = 0,
  });

  bool get hasSelectedDate =>
      selectedMonths.isNotEmpty || (startDate != null && endDate != null);

  String get formattedDateText {
    if (bookingType == BookingType.monthly) {
      if (selectedMonths.isEmpty) return "Select one or more months";

      // Sort months to ensure they appear in order (Jan, Feb, Mar)
      final sortedMonths = List<DateTime>.from(selectedMonths)
        ..sort((a, b) => a.compareTo(b));

      // Format like: "January, February, March"
      return sortedMonths
          .map((date) => DateFormat('MMMM').format(date))
          .join(', ');
    } else {
      // Nightly Logic
      if (startDate == null) return "Select check-in date";
      if (endDate == null) return "Select check-out date";

      // Format like: "Jan 12 - Jan 15"
      final start = DateFormat('MMM dd').format(startDate!);
      final end = DateFormat('MMM dd').format(endDate!);
      return "$start - $end";
    }
  }

  @override
  List<Object?> get props => [
    bookingType,
    totalDuration,
    totalPrice,
    startDate,
    endDate,
    selectedMonths,
  ];

  CalendarState copyWith({
    BookingType? bookingType,
    List<DateTime>? selectedMonths,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    int? totalDuration,
  }) {
    return CalendarState(
      bookingType: bookingType ?? this.bookingType,
      selectedMonths: selectedMonths ?? this.selectedMonths,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}
