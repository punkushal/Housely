import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

import '../../../../../core/usecases/usecase.dart';

class GetNearbyPropertiesUseCase
    implements
        UseCase<
          ({List<Property> data, DocumentSnapshot? lastDoc}),
          NearbyParam
        > {
  final PropertyRepo repo;

  GetNearbyPropertiesUseCase(this.repo);

  @override
  ResultFuture<({List<Property> data, DocumentSnapshot<Object?>? lastDoc})>
  call(NearbyParam params) {
    return repo.fetchNearbyProperties(
      latitude: params.latitude,
      longitude: params.longitude,
      lastDoc: params.lastDoc,
    );
  }
}

class NearbyParam extends Equatable {
  final double latitude;
  final double longitude;
  final DocumentSnapshot? lastDoc;

  const NearbyParam({
    required this.latitude,
    required this.longitude,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [latitude, longitude, lastDoc];
}
