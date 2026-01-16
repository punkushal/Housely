import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';

abstract interface class BookingRepo {
  // Request booking
  ResultVoid requestBooking(Booking booking);

  // Respond/update booking status
  ResultVoid respondBooking({
    required String bookingId,
    required BookingStatus status,
  });

  // Listen booking changes
  ResultStream<List<Booking>> get listenBookingChanges;
}
