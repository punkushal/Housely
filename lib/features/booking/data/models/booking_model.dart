import 'package:housely/features/booking/domain/entity/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.bookingId,
    required super.propertyId,
    required super.tenantId,
    required super.ownerId,
    required super.amount,
    super.bookingStatus,
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
    );
  }

  // From model class to firestore
  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'propertyId': propertyId,
    'tenantId': tenantId,
    'ownerId': ownerId,
    'amount': amount,
    'bookingStatus': bookingStatus,
  };

  @override
  BookingModel copyWith({
    String? bookingId,
    String? propertyId,
    String? tenantId,
    String? ownerId,
    BookingStatus? bookingStatus,
    double? amount,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      ownerId: ownerId ?? this.ownerId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      amount: amount ?? this.amount,
    );
  }
}
