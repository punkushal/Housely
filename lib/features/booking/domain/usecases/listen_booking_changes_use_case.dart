import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class ListenBookingChangesUseCase implements UseCaseWithStream {
  final BookingRepo bookingRepo;

  ListenBookingChangesUseCase(this.bookingRepo);
  @override
  ResultStream<List<Booking>> call() {
    return bookingRepo.listenBookingChanges;
  }
}
