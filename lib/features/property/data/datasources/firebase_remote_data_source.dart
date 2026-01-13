import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/property/data/models/property_model.dart';
import 'package:housely/features/property/data/models/property_owner_model.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';

class FirebaseRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  FirebaseRemoteDataSource({required this.firestore, required this.auth});

  // add newly created property data
  Future<void> addNewProperty(PropertyModel property) async {
    try {
      final docRef = firestore
          .collection(TextConstants.properties)
          .doc(); // it will auto generate id for property

      final updatedProperty = property.copyWith(id: docRef.id);

      await docRef.set(updatedProperty.toJson());
    } catch (e) {
      throw Exception('Failed to add new property: $e');
    }
  }

  // delete property
  Future<void> deleteProperty(String propertyId) async {
    try {
      await firestore
          .collection(TextConstants.properties)
          .doc(propertyId)
          .delete();
    } catch (e) {
      throw Exception('Failed to add new property: $e');
    }
  }

  // search and filter properties
  Future<({List<Property> data, DocumentSnapshot? lastDoc})> searchAndFilters({
    required PropertyFilterParams filters,
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection(
        TextConstants.properties,
      );

      // filter by property type
      if (filters.propertyTypes.isNotEmpty &&
          filters.propertyTypes.length <= 30) {
        query = query.where('type', whereIn: filters.propertyTypes);
      }
      if (filters.propertyStatus.isNotEmpty &&
          filters.propertyStatus.length <= 30) {
        query = query.where('status', whereIn: filters.propertyStatus);
      }

      if (filters.priceRange != null) {
        final minPrice = filters.priceRange!.start.toInt();
        final maxPrice = filters.priceRange!.end.toInt();
        query = query
            .where('price.amount', isGreaterThanOrEqualTo: minPrice)
            .where('price.amount', isLessThanOrEqualTo: maxPrice)
            .orderBy('price.amount');
      }

      // pagination
      query = query.limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      final jsonList = snapshot.docs;
      final newLastDoc = jsonList.isNotEmpty ? jsonList.last : null;
      var propertyList = jsonList
          .map((doc) => PropertyModel.fromJson(doc.data()))
          .toList();

      if (filters.facilities != null && filters.facilities!.isNotEmpty) {
        propertyList = propertyList.where((p) {
          final propertyFacilities = p.facilities
              .map((e) => e.toLowerCase())
              .toList();

          return filters.facilities!.every(
            (facility) => propertyFacilities.contains(facility),
          );
        }).toList();
      }

      if (filters.searchQuery != null) {
        final searchTitle = filters.searchQuery!.toLowerCase();

        propertyList = propertyList
            .where(
              (property) =>
                  (property.name.toLowerCase() == searchTitle) ||
                  (property.location.address.toLowerCase() == searchTitle),
            )
            .toList();

        return (data: propertyList, lastDoc: newLastDoc);
      }
      return (data: propertyList, lastDoc: newLastDoc);
    } catch (e) {
      throw Exception('Failed to fetch all properties: $e');
    }
  }

  // fetch all the properties
  Future<List<Property>> fetchAllProperties() async {
    try {
      final snapshot = await firestore
          .collection(TextConstants.properties)
          .get();
      final jsonList = snapshot.docs;
      final propertyList = jsonList
          .map((doc) => PropertyModel.fromJson(doc.data()))
          .toList();
      return propertyList;
    } catch (e) {
      throw Exception('Failed to fetch all properties: $e');
    }
  }

  // update property
  Future<void> updateProperty(PropertyModel property) async {
    try {
      await firestore
          .collection(TextConstants.properties)
          .doc(property.id)
          .update(property.toJson());
    } catch (e) {
      throw Exception('Failed to update reqeuest property: $e');
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

  // create property owner profile data
  Future<void> createOwnerProfile(PropertyOwnerModel owner) async {
    try {
      // added uid for owner id
      final model = owner.copyWith(ownerId: auth.currentUser!.uid);
      final docId = auth.currentUser!.email;
      await firestore
          .collection(TextConstants.owners)
          .doc(docId!)
          .set(model.toJson());
    } catch (e) {
      throw Exception('Failed to create owner profile: $e');
    }
  }

  // get owner profile
  Future<PropertyOwnerModel?> getOwnerProfile() async {
    try {
      final docRef = firestore
          .collection(TextConstants.owners)
          .doc(auth.currentUser!.email);

      final result = await docRef.get();
      if (result.data() == null) return null;
      return PropertyOwnerModel.fromJson(result.data()!);
    } catch (e) {
      throw Exception("Failed to fetch owner profile: $e");
    }
  }
}
