part of 'payment_history_cubit.dart';

sealed class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object?> get props => [];
}

final class PaymentHistoryInitial extends PaymentHistoryState {}

final class PaymentHistoryLoading extends PaymentHistoryState {}

final class FetchAllPaymentHistory extends PaymentHistoryState {
  final String tenantId;
  final DocumentSnapshot? lastDoc;

  const FetchAllPaymentHistory({required this.tenantId, this.lastDoc});

  @override
  List<Object?> get props => [tenantId, lastDoc];
}

final class PaymentHistoryLoaded extends PaymentHistoryState {
  final List<BookingDetail> allPaymentHistoryList;
  final DocumentSnapshot? lastDoc;
  const PaymentHistoryLoaded({
    required this.allPaymentHistoryList,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [allPaymentHistoryList, lastDoc];
}

final class PaymentHistoryFailure extends PaymentHistoryState {
  final String message;

  const PaymentHistoryFailure(this.message);

  @override
  List<Object> get props => [message];
}
