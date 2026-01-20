import 'package:equatable/equatable.dart';
import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/booking/domain/repository/esewa_payment_repo.dart';

class InitiateEsewaPayUseCase
    implements UseCase<EsewaPaymentResult, PaymentParams> {
  final EsewaPaymentRepo esewaPaymentRepo;

  InitiateEsewaPayUseCase(this.esewaPaymentRepo);
  @override
  ResultFuture<EsewaPaymentResult> call(esewaParam) async {
    return await esewaPaymentRepo.initiateEsewaPayment(
      context: esewaParam.context,
      esewaConfig: esewaParam.eSewaConfig,
    );
  }
}

class PaymentParams extends Equatable {
  final ESewaConfig eSewaConfig;
  final BuildContext context;

  const PaymentParams({required this.eSewaConfig, required this.context});

  @override
  List<Object> get props => [eSewaConfig, context];
}
