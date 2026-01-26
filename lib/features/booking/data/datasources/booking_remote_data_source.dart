import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:housely/features/booking/data/models/booking_model.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/property/data/models/property_model.dart';

class BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  final AuthRemoteDataSource authRemoteDataSource;
  BookingRemoteDataSource({
    required this.authRemoteDataSource,
    required this.firestore,
  });

  // Request booking
  Future<void> requestBooking(Booking booking) async {
    try {
      final currentUser = await authRemoteDataSource.getCurrentUser();
      final docRef = firestore.collection(TextConstants.bookings).doc();

      final updatedBooking = booking.copyWith(
        bookingId: docRef.id,
        tenantId: currentUser!.uid,
      );

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
  Stream<List<BookingDetail>> listenBookingChanges() async* {
    try {
      final currentUser = await authRemoteDataSource.getCurrentUser();
      if (currentUser == null) return;

      // listent to bookings
      yield* firestore
          .collection(TextConstants.bookings)
          .where('tenantId', isEqualTo: currentUser.uid)
          .snapshots()
          .asyncMap((bookingSnapshot) async {
            List<BookingDetail> combinedList = [];

            for (var doc in bookingSnapshot.docs) {
              final booking = BookingModel.fromJson(doc.data());

              // Fetch the property for this specific booking
              final propertyDoc = await firestore
                  .collection(TextConstants.properties)
                  .doc(booking.propertyId)
                  .get();

              if (propertyDoc.exists) {
                final property = PropertyModel.fromJson(propertyDoc.data()!);
                combinedList.add(
                  BookingDetail(booking: booking, property: property),
                );
              }
            }
            return combinedList;
          });
    } catch (e) {
      throw Exception("Failed to listen for booking changes: $e");
    }
  }

  Future<List<BookingDetail>> getBookingRequestList() async {
    try {
      final currentUser = await authRemoteDataSource.getCurrentUser();
      if (currentUser == null) return [];

      final snapshots = await firestore
          .collection(TextConstants.bookings)
          .where('ownerId', isEqualTo: currentUser.uid)
          .where('bookingStatus', isEqualTo: 'pending')
          .get();

      List<BookingDetail> combinedList = [];

      for (var doc in snapshots.docs) {
        final booking = BookingModel.fromJson(doc.data());

        // Fetch the property for this specific booking
        final propertyDoc = await firestore
            .collection(TextConstants.properties)
            .doc(booking.propertyId)
            .get();

        if (propertyDoc.exists) {
          final property = PropertyModel.fromJson(propertyDoc.data()!);
          combinedList.add(BookingDetail(booking: booking, property: property));
        }
      }

      return combinedList;
    } catch (e) {
      throw Exception("Failed to fetch booking request list: $e");
    }
  }
}
