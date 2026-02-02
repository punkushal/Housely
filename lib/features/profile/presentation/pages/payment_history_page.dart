import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/profile/presentation/cubit/payments/cubit/payment_history_cubit.dart';
import 'package:housely/features/profile/presentation/widgets/payment_history_card.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state as Authenticated;
    return BlocProvider(
      create: (context) =>
          sl<PaymentHistoryCubit>()
            ..getAllPaymentHistoryList(tenantId: authState.currentUser!.uid),
      child: Builder(
        builder: (context) {
          return BlocListener<PaymentHistoryCubit, PaymentHistoryState>(
            listener: (context, state) {
              if (state is PaymentHistoryFailure) {
                return SnackbarHelper.showError(context, state.message);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.surface.withValues(alpha: 0.95),
              appBar: AppBar(title: Text("Payment History")),
              body: BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
                builder: (context, state) {
                  if (state is PaymentHistoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PaymentHistoryLoaded) {
                    if (state.allPaymentHistoryList.isEmpty) {
                      return Center(child: Text('No payment history'));
                    }
                    return ListView.builder(
                      itemCount: state.allPaymentHistoryList.length,
                      itemBuilder: (context, index) {
                        return PaymentHistoryCard(
                          property: state.allPaymentHistoryList[index].property,
                          booking: state.allPaymentHistoryList[index].booking,
                        );
                      },
                    );
                  } else if (state is PaymentHistoryFailure) {
                    return Center(child: Text(state.message));
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
