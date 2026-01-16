import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/booking/data/models/booking_model.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';

class BookingRemoteDataSource {
  final FirebaseFirestore firestore;

  BookingRemoteDataSource(this.firestore);

  // Request booking
  Future<void> requestBooking(Booking booking) async {
    try {
      final docRef = firestore.collection(TextConstants.bookings).doc();

      final updatedBooking = booking.copyWith(bookingId: docRef.id);

      docRef.set(BookingModel.fromEntity(updatedBooking).toJson());
    } catch (e) {
      throw Exception("Failed to request booking: $e");
    }
  }

  // Respond booking
  Future<void> respondBooking({
    required String bookingId,
    required BookingStatus status,
  }) async {
    try {
      await firestore.collection(TextConstants.bookings).doc(bookingId).update({
        'bookingStatus': status.name,
      });
    } catch (e) {
      throw Exception("Failed to response booking: $e");
    }
  }

  // Listen booking changes
  Stream<List<Booking>> listenBookingChanges() async* {
    final snapshots = await firestore.collection(TextConstants.bookings).get();
    final jsonList = snapshots.docs;
    final bookingList = jsonList
        .map((doc) => BookingModel.fromJson(doc.data()))
        .toList();
    yield bookingList;
  }
}
