import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.bookingId,
    required super.propertyId,
    required super.tenantId,
    required super.ownerId,
    required super.amount,
    super.selectedMonths,
    super.bookingStatus,
    super.startDate,
    super.endDate,
  });

  // From firestore to model class
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      propertyId: json['propertyId'],
      tenantId: json['tenantId'],
      ownerId: json['ownerId'],
      amount: json['amount'],
      bookingStatus: BookingStatus.values.byName(json['bookingStatus']),
      selectedMonths: (json['selectedMonths'] as List)
          .map((e) => (e as Timestamp).toDate())
          .toList(),
      startDate: (json['startDate'] as Timestamp?)?.toDate(),
      endDate: (json['endDate'] as Timestamp?)?.toDate(),
    );
  }

  // from entity class to model class
  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      bookingId: booking.bookingId,
      propertyId: booking.propertyId,
      tenantId: booking.tenantId,
      ownerId: booking.ownerId,
      amount: booking.amount,
      bookingStatus: booking.bookingStatus,
      selectedMonths: booking.selectedMonths,
      startDate: booking.startDate,
      endDate: booking.endDate,
    );
  }

  // From model class to firestore
  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'propertyId': propertyId,
    'tenantId': tenantId,
    'ownerId': ownerId,
    'amount': amount,
    'bookingStatus': bookingStatus.name,
    'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
    'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    'selectedMonths': selectedMonths.map((e) => Timestamp.fromDate(e)).toList(),
  };

  @override
  BookingModel copyWith({
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
    return BookingModel(
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
}
