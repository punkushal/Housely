import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:housely/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:housely/features/booking/presentation/cubit/calendar_cubit.dart';
import 'package:housely/features/booking/presentation/widgets/booking_property_card.dart';
import 'package:housely/features/booking/presentation/widgets/custom_note.dart';
import 'package:housely/features/booking/presentation/widgets/date_period_picker.dart';
import 'package:housely/features/booking/presentation/widgets/payment_section.dart';
import 'package:housely/features/booking/presentation/widgets/price_details.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class BookingPage extends StatelessWidget {
  const BookingPage({super.key, required this.property});
  final Property property;

  void showBookingSuccess(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: Column(
          spacing: ResponsiveDimensions.spacing16(context),
          children: [
            Image.asset(ImageConstant.bookingSuccessImg),
            SizedBox(height: ResponsiveDimensions.spacing16(context)),
            Text(
              "Yey, your booking succes",
              style: AppTextStyle.headingSemiBold(
                context,
                fontSize: 20,
                lineHeight: 26,
              ),
            ),

            Text(
              "you have successfully booked a property, enjoy your property",
              style: AppTextStyle.bodyRegular(
                context,
                fontSize: 14,
                color: AppColors.textHint,
              ),
              textAlign: .center,
            ),

            CustomButton(
              onTap: () {
                context.router.replaceAll([TabWrapper()]);
              },
              buttonLabel: 'Explore more',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<BookingBloc>()..add(ListenBookingChangesEvent()),
        ),
        BlocProvider(create: (context) => sl<CalendarCubit>()),
        BlocProvider(create: (context) => sl<PaymentBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is BookingLoaded) {
                    final existing = state.allBookings.any(
                      (b) => b.property.id == property.id,
                    );

                    if (existing) {
                      final bookingDetail = state.allBookings.firstWhere(
                        (b) => b.property.id == property.id,
                      );
                      context.read<CalendarCubit>().setExistingBookingDates(
                        type: property.type.name.toLowerCase() == 'house'
                            ? .monthly
                            : .nightly,
                        amount: bookingDetail.booking.amount,
                        start: bookingDetail.booking.startDate,
                        end: bookingDetail.booking.endDate,
                        months: bookingDetail.booking.selectedMonths,
                      );
                    }
                  }
                  if (state is BookingSuccess) {
                    SnackbarHelper.showSuccess(
                      context,
                      "Booking request is successfully sent",
                      showTop: true,
                    );
                  } else if (state is BookingFailure) {
                    SnackbarHelper.showError(
                      context,
                      state.message,
                      showTop: true,
                    );
                  }
                },
              ),
              BlocListener<PaymentBloc, PaymentState>(
                listener: (context, state) {
                  if (state is PaymentSuccess) {
                    SnackbarHelper.showSuccess(
                      context,
                      "Payment with esewa successful",
                      showTop: true,
                    );
                    // Find the active booking to update
                    final bookingState = context.read<BookingBloc>().state;
                    if (bookingState is BookingLoaded) {
                      final activeBooking = bookingState.allBookings
                          .cast<BookingDetail?>()
                          .firstWhere(
                            (b) =>
                                b?.property.id == property.id &&
                                b?.booking.bookingStatus ==
                                    BookingStatus.accepted,
                            orElse: () => null,
                          );

                      if (activeBooking != null) {
                        // Trigger status update to 'Completed'
                        context.read<BookingBloc>().add(
                          ResponseBookingRequestEvent(
                            status: BookingStatus.completed,
                            bookingId: activeBooking.booking.bookingId,
                          ),
                        );
                        // Show your custom success modal
                        showBookingSuccess(context);
                      }
                    }
                  } else if (state is PaymentFailure) {
                    SnackbarHelper.showError(
                      context,
                      state.message,
                      showTop: true,
                    );
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(title: Text('Booking')),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 24,
                    ),
                    child: Column(
                      spacing: ResponsiveDimensions.spacing24(context),
                      crossAxisAlignment: .start,
                      children: [
                        BookingPropertyCard(property: property),
                        DatePeriodPicker(
                          price: property.price.amount,
                          propertyType: property.type.name,
                        ),

                        // Payment section
                        PaymentSection(),

                        // Price detail
                        BlocBuilder<CalendarCubit, CalendarState>(
                          builder: (context, state) {
                            if (!state.hasSelectedDate) {
                              return SizedBox.shrink();
                            }
                            return PriceDetails(
                              price: property.price.amount,
                              propertyType: property.type.name,
                            );
                          },
                        ),

                        CustomNote(),

                        BlocBuilder<CalendarCubit, CalendarState>(
                          builder: (context, dateState) {
                            return BlocBuilder<BookingBloc, BookingState>(
                              builder: (context, bookingstate) {
                                bool isLoading =
                                    bookingstate is BookingLoading ||
                                    context.watch<PaymentBloc>().state
                                        is PaymentLoading;
                                bool isButtonEnabled =
                                    dateState.hasSelectedDate;

                                BookingDetail? existingBooking;
                                String buttonLabel = 'Request booking';
                                VoidCallback? onTap;

                                if (bookingstate is BookingLoaded) {
                                  final existing = bookingstate.allBookings.any(
                                    (b) {
                                      return b.property.id == property.id;
                                    },
                                  );
                                  if (existing) {
                                    existingBooking = bookingstate.allBookings
                                        .firstWhere((b) {
                                          return b.property.id == property.id;
                                        });

                                    switch (existingBooking
                                        .booking
                                        .bookingStatus) {
                                      case .pending:
                                        buttonLabel = "Check status";
                                        isButtonEnabled = true;
                                        onTap = () {
                                          context.router.push(MyBookingRoute());
                                        };
                                        break;

                                      case .accepted:
                                        buttonLabel = "Confirm and Pay";
                                        isButtonEnabled = true;
                                        onTap = () {
                                          context.read<PaymentBloc>().add(
                                            PayWithEsewa(
                                              context,
                                              existingBooking!.booking,
                                            ),
                                          );
                                        };
                                        break;

                                      case .completed:
                                        buttonLabel = "Booked Successfully";
                                        isButtonEnabled = false;
                                        break;

                                      case .cancelled:
                                        buttonLabel =
                                            "Request Rejected (Retry)";
                                        isButtonEnabled = true;
                                        break;
                                    }
                                  }
                                }
                                // Default Initial Request Logic
                                onTap ??= () {
                                  context.read<BookingBloc>().add(
                                    RequestBookingEvent(
                                      Booking(
                                        bookingId: "",
                                        propertyId: property.id!,
                                        tenantId: "",
                                        ownerId: property.owner.ownerId,
                                        amount: dateState.totalPrice,
                                        startDate: dateState.startDate,
                                        endDate: dateState.endDate,
                                        selectedMonths:
                                            dateState.selectedMonths,
                                      ),
                                    ),
                                  );
                                };
                                return CustomButton(
                                  onTap: isButtonEnabled ? onTap : null,
                                  buttonLabel: buttonLabel,
                                  isLoading: isLoading,
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(
                          height: ResponsiveDimensions.spacing12(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
