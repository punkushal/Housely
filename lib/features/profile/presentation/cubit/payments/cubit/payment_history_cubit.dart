// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:housely/features/profile/domain/usecases/get_payment_history_use_case.dart';

import '../../../../../booking/domain/entity/booking_detail.dart';

part 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final GetPaymentHistoryUseCase getPaymentHistoryUseCase;
  PaymentHistoryCubit(this.getPaymentHistoryUseCase)
    : super(PaymentHistoryInitial());

  Future<void> getAllPaymentHistoryList({
    required String tenantId,
    DocumentSnapshot? lastDoc,
  }) async {
    emit(PaymentHistoryLoading());
    final result = await getPaymentHistoryUseCase(
      GetHistoryParam(tenantId: tenantId, lastDoc: lastDoc),
    );

    result.fold((f) => emit(PaymentHistoryFailure(f.message)), (data) {
      emit(
        PaymentHistoryLoaded(
          allPaymentHistoryList: data.history,
          lastDoc: data.lastDoc,
        ),
      );
    });
  }
}
