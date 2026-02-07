// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class RequestBookingUseCase implements UseCase<void, RequestParam> {
  BookingRepo bookingRepo;
  RequestBookingUseCase(this.bookingRepo);
  @override
  ResultFuture<void> call(param) async {
    return await bookingRepo.requestBooking(param.booking);
  }
}

class RequestParam extends Equatable {
  final Booking booking;

  const RequestParam(this.booking);

  @override
  List<Object?> get props => [booking];
}
