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

final class LoadedBookingEvent extends BookingEvent {
  final List<Booking> bookingList;

  const LoadedBookingEvent(this.bookingList);

  @override
  List<Object> get props => [bookingList];
}

final class AcceptBookingEvent extends BookingEvent {
  final String bookingId;

  const AcceptBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

final class CancelBookingEvent extends BookingEvent {
  final String bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

final class CompleteBookingEvent extends BookingEvent {
  final String bookingId;

  const CompleteBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}
