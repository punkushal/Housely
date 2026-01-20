// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class RespondBookingUseCase implements UseCase<void, RespondParams> {
  BookingRepo bookingRepo;
  RespondBookingUseCase(this.bookingRepo);
  @override
  ResultFuture<void> call(param) async {
    return await bookingRepo.respondBooking(
      bookingId: param.bookingId,
      status: param.status,
    );
  }
}

class RespondParams extends Equatable {
  final String bookingId;
  final BookingStatus status;

  const RespondParams({required this.bookingId, required this.status});

  @override
  List<Object?> get props => [bookingId, status];
}
