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

  const Booking({
    required this.bookingId,
    required this.propertyId,
    required this.tenantId,
    required this.ownerId,
    this.bookingStatus = .pending,
    required this.amount,
  });

  Booking copyWith({
    String? bookingId,
    String? propertyId,
    String? tenantId,
    String? ownerId,
    BookingStatus? bookingStatus,
    double? amount,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      ownerId: ownerId ?? this.ownerId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      amount: amount ?? this.amount,
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
  ];
}
