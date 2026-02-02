import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/profile/data/datasources/payment_history_remote_data_source.dart';
import 'package:housely/features/profile/domain/repository/payment_history_repo.dart';

class PaymentHistoryRepoImpl implements PaymentHistoryRepo {
  final PaymentHistoryRemoteDataSource remoteDataSource;

  PaymentHistoryRepoImpl(this.remoteDataSource);
  @override
  ResultFuture<
    ({List<BookingDetail> history, DocumentSnapshot<Object?>? lastDoc})
  >
  fetchPaymentHistory({
    required String tenantId,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      final result = await remoteDataSource.fetchPaymentHistory(
        tenantId: tenantId,
        lastDoc: lastDoc,
      );

      return Right(result);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(
        ServerFailure("Failed to get payment history: ${e.toString()}"),
      );
    }
  }
}
