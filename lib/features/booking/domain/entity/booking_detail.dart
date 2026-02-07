import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class BookingDetail {
  final Booking booking;
  final Property property;

  BookingDetail({required this.booking, required this.property});
}
