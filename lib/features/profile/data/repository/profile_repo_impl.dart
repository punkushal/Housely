import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl(this.remoteDataSource);
  @override
  ResultVoid reauthenticateUser(String password) async {
    try {
      await remoteDataSource.reauthenticateUser(password);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? "Re-authentication failed"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateUserProfile({
    required AppUser currentUser,
    PropertyOwner? currnetOwner,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        appUser: currentUser,
        owner: currnetOwner,
      );

      return Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(ServerFailure('requires-recent-login'));
      }
      return Left(ServerFailure(e.message ?? "Email update failed"));
    } catch (e) {
      return Left(
        ServerFailure("Failed to update user profile: ${e.toString()}"),
      );
    }
  }
}
