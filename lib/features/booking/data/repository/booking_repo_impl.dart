import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/domain/repository/booking_repo.dart';

class BookingRepoImpl implements BookingRepo {
  final BookingRemoteDataSource dataSource;

  BookingRepoImpl(this.dataSource);
  @override
  ResultStream<List<BookingDetail>> get listenBookingChanges =>
      dataSource.listenBookingChanges();

  @override
  ResultVoid requestBooking(Booking booking) async {
    try {
      await dataSource.requestBooking(booking);
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to request booking"));
    }
  }

  @override
  ResultVoid respondBooking({
    required String bookingId,
    required BookingStatus status,
  }) async {
    try {
      await dataSource.respondBooking(bookingId: bookingId, status: status);
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to respond booking"));
    }
  }
}
