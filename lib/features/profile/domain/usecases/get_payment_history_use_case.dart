import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/profile/domain/repository/payment_history_repo.dart';

class GetPaymentHistoryUseCase
    implements
        UseCase<
          ({List<BookingDetail> history, DocumentSnapshot? lastDoc}),
          GetHistoryParam
        > {
  final PaymentHistoryRepo paymentHistoryRepo;

  GetPaymentHistoryUseCase(this.paymentHistoryRepo);
  @override
  ResultFuture<({List<BookingDetail> history, DocumentSnapshot? lastDoc})> call(
    params,
  ) async {
    return paymentHistoryRepo.fetchPaymentHistory(
      tenantId: params.tenantId,
      lastDoc: params.lastDoc,
    );
  }
}

class GetHistoryParam extends Equatable {
  final String tenantId;
  final DocumentSnapshot? lastDoc;

  const GetHistoryParam({required this.tenantId, this.lastDoc});

  @override
  List<Object?> get props => [tenantId, lastDoc];
}
