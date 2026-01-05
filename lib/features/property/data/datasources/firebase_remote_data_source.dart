import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/property/data/models/property_model.dart';

class FirebaseRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  FirebaseRemoteDataSource({required this.firestore, required this.auth});

  // add newly created property data
  Future<void> addNewProperty(PropertyModel property) async {
    try {
      final docId = auth.currentUser!.email;
      await firestore
          .collection(TextConstants.properties)
          .doc(docId)
          .set(property.toJson());
    } catch (e) {
      throw Exception('Failed to add new property: $e');
    }
  }

  // get currently logged in user's email
  Future<String> getOwnerEmail() async {
    try {
      return auth.currentUser!.email!;
    } catch (e) {
      throw Exception("Failed to get email: $e");
    }
  }
}
