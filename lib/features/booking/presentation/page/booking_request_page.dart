import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:housely/features/booking/presentation/widgets/booking_request_card.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class BookingRequestPage extends StatelessWidget {
  const BookingRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CalendarCubit()),
        BlocProvider(
          create: (context) =>
              sl<BookingBloc>()..add(LoadBookingRequestEvent()),
        ),
      ],
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            context.read<BookingBloc>().add(LoadBookingRequestEvent());
            SnackbarHelper.showSuccess(
              context,
              "The response will be notify to the user",
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Booking Request')),
          body: SafeArea(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is BookingLoaded) {
                  if (state.allBookings.isEmpty) {
                    return Center(child: Text('No requests'));
                  }

                  return ListView.builder(
                    itemCount: state.allBookings.length,
                    itemBuilder: (context, index) {
                      final bookingDetail = state.allBookings[index];
                      context.read<CalendarCubit>().setExistingBookingDates(
                        amount: bookingDetail.booking.amount,
                        type: bookingDetail.property.type.name == 'house'
                            ? .monthly
                            : .nightly,
                        start: bookingDetail.booking.startDate,
                        end: bookingDetail.booking.endDate,
                        months: bookingDetail.booking.selectedMonths,
                      );
                      return BookingRequestCard(bookingDetail);
                    },
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
