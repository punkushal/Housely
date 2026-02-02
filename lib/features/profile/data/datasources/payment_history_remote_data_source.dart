import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/booking/data/models/booking_model.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/property/data/models/property_model.dart';

class PaymentHistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  PaymentHistoryRemoteDataSource(this.firestore);

  Future<({List<BookingDetail> history, DocumentSnapshot? lastDoc})>
  fetchPaymentHistory({
    required String tenantId,
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) async {
    Query<Map<String, dynamic>> query = firestore
        .collection(TextConstants.bookings)
        .where("tenantId", isEqualTo: tenantId)
        .where("bookingStatus", isEqualTo: "completed");

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    final jsonList = snapshot.docs;

    List<BookingDetail> combinedList = [];

    for (var doc in snapshot.docs) {
      final booking = BookingModel.fromJson(doc.data());

      final propertyDoc = await firestore
          .collection(TextConstants.properties)
          .doc(booking.propertyId)
          .get();

      if (propertyDoc.exists) {
        final property = PropertyModel.fromJson(propertyDoc.data()!);

        combinedList.add(BookingDetail(booking: booking, property: property));
      }
    }

    final newLastDoc = jsonList.isNotEmpty ? jsonList.last : null;

    return (history: combinedList, lastDoc: newLastDoc);
  }
}
