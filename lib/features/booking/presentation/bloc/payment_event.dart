part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

final class PayWithEsewa extends PaymentEvent {
  final Booking booking;
  final BuildContext conext;

  const PayWithEsewa(this.conext, this.booking);

  @override
  List<Object> get props => [booking];
}
