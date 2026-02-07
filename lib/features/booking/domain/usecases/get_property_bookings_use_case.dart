import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class GetPropertyBookingsUseCase
    implements UseCase<List<Booking>, GetPropertyBookingParam> {
  final BookingRepo bookingRepo;

  GetPropertyBookingsUseCase(this.bookingRepo);
  @override
  ResultFuture<List<Booking>> call(params) async {
    return await bookingRepo.getPropertyBookings(params.propertyId);
  }
}

class GetPropertyBookingParam extends Equatable {
  final String propertyId;

  const GetPropertyBookingParam(this.propertyId);
  @override
  List<Object?> get props => [propertyId];
}
