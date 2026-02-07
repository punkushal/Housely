part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

final class RequestBookingEvent extends BookingEvent {
  final Booking booking;

  const RequestBookingEvent(this.booking);

  @override
  List<Object> get props => [booking];
}

final class ListenBookingChangesEvent extends BookingEvent {}

final class LoadBookingRequestEvent extends BookingEvent {}

class LoadPropertyBookingsEvent extends BookingEvent {
  final String propertyId;
  const LoadPropertyBookingsEvent(this.propertyId);

  @override
  List<Object> get props => [propertyId];
}

final class ResponseBookingRequestEvent extends BookingEvent {
  final BookingStatus status;
  final String bookingId;

  const ResponseBookingRequestEvent({
    required this.status,
    required this.bookingId,
  });

  @override
  List<Object> get props => [status, bookingId];
}
