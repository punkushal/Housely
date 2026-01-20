// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum BookingStatus { pending, accepted, completed, cancelled }

class Booking extends Equatable {
  final String bookingId;
  final String propertyId;
  final String tenantId;
  final String ownerId;
  final BookingStatus bookingStatus;
  final double amount;
  final List<DateTime> selectedMonths;
  final DateTime? startDate;
  final DateTime? endDate;

  const Booking({
    required this.bookingId,
    required this.propertyId,
    required this.tenantId,
    required this.ownerId,
    this.bookingStatus = .pending,
    required this.amount,
    this.selectedMonths = const [],
    this.startDate,
    this.endDate,
  });

  Booking copyWith({
    String? bookingId,
    String? propertyId,
    String? tenantId,
    String? ownerId,
    BookingStatus? bookingStatus,
    double? amount,
    List<DateTime>? selectedMonths,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      ownerId: ownerId ?? this.ownerId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      amount: amount ?? this.amount,
      selectedMonths: selectedMonths ?? this.selectedMonths,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
    bookingId,
    bookingStatus,
    ownerId,
    propertyId,
    amount,
    tenantId,
    selectedMonths,
    startDate,
    endDate,
  ];
}
