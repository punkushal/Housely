import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';

abstract interface class PaymentHistoryRepo {
  ResultFuture<({List<BookingDetail> history, DocumentSnapshot? lastDoc})>
  fetchPaymentHistory({
    required String tenantId,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  });
}
