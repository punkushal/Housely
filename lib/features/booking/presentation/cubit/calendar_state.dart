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
