part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingSuccess extends BookingState {}

final class BookingLoaded extends BookingState {
  final List<Booking> allBookings;

  const BookingLoaded(this.allBookings);

  @override
  List<Object> get props => [allBookings];
}

final class BookingFailure extends BookingState {
  final String message;

  const BookingFailure(this.message);

  @override
  List<Object> get props => [message];
}
