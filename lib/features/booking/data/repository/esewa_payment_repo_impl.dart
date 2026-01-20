import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/data/datasources/esewa_remote_data_source.dart';
import 'package:housely/features/booking/domain/repository/esewa_payment_repo.dart';

class EsewaPaymentRepoImpl implements EsewaPaymentRepo {
  final EsewaRemoteDataSource dataSource;

  EsewaPaymentRepoImpl(this.dataSource);
  @override
  ResultFuture<EsewaPaymentResult> initiateEsewaPayment({
    required BuildContext context,
    required ESewaConfig esewaConfig,
  }) async {
    try {
      final result = await dataSource.payWithEsewa(
        context: context,
        esewaConfig: esewaConfig,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure("Failed to pay with esewa : $e"));
    }
  }
}
