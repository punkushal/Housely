import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/env/env.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/usecases/initiate_esewa_pay_use_case.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiateEsewaPayUseCase initiateEsewaPayUseCase;
  PaymentBloc(this.initiateEsewaPayUseCase) : super(PaymentInitial()) {
    on<PayWithEsewa>(_onPayWithEsewa);
  }

  Future<void> _onPayWithEsewa(
    PayWithEsewa event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await initiateEsewaPayUseCase(
      PaymentParams(
        context: event.conext,
        eSewaConfig: .dev(
          amount: event.booking.amount,
          successUrl: TextConstants.esewaSucessUrl,
          failureUrl: TextConstants.esewaFailureUrl,
          secretKey: Env.secretKey,
        ),
      ),
    );

    result.fold((f) => emit(PaymentFailure(f.message)), (result) {
      if (result.hasData) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentFailure(result.error!));
      }
    });
  }
}
