import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class GetBookingRequestListUseCase implements UseCaseWithoutParams {
  final BookingRepo bookingRepo;

  GetBookingRequestListUseCase(this.bookingRepo);
  @override
  ResultFuture<List<BookingDetail>> call() async {
    return await bookingRepo.bookingRequestList;
  }
}
