import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:housely/features/booking/presentation/widgets/my_booking_card.dart';
import 'package:housely/features/booking/presentation/widgets/no_booking_message.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<MyBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Helper method to build the list based on status
  Widget _buildBookingList(List<BookingDetail> details, String status) {
    // FILTER the list based on the tab requirement
    final filteredList = details
        .where((d) => d.booking.bookingStatus.name == status)
        .toList();

    if (filteredList.isEmpty) {
      return Center(child: NoBookingMessage(status));
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        final property = item.property;
        final booking = item.booking;

        return GestureDetector(
          onTap: () => context.router.push(BookingRoute(property: property)),
          child: MyBookingCard(property: property, booking: booking),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingBloc>()..add(ListenBookingChangesEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Booking'),
              bottom: PreferredSize(
                preferredSize: Size(
                  double.infinity,
                  ResponsiveDimensions.getSize(context, 44),
                ),
                child: Padding(
                  padding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 24,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E7EB),
                      borderRadius: ResponsiveDimensions.borderRadiusSmall(
                        context,
                      ),
                    ),

                    child: TabBar(
                      controller: tabController,
                      labelStyle: AppTextStyle.bodyMedium(
                        context,
                        color: AppColors.surface,
                      ),
                      unselectedLabelStyle: AppTextStyle.bodyRegular(
                        context,
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                      dividerHeight: 0,
                      indicatorSize: .tab,
                      indicator: BoxDecoration(
                        borderRadius: ResponsiveDimensions.borderRadiusSmall(
                          context,
                        ),
                        color: AppColors.primary,
                      ),
                      indicatorPadding: ResponsiveDimensions.paddingSymmetric(
                        context,
                        horizontal: 4,
                        vertical: 6,
                      ),
                      tabs: [
                        Tab(text: 'Pending'),
                        Tab(text: 'Completed'),
                        Tab(text: 'Cancelled'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                //  HANDLE LOADING
                if (state is BookingLoading || state is BookingInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                // HANDLE ERROR
                if (state is BookingFailure) {
                  return Center(child: Text(state.message));
                }

                // HANDLE SUCCESS
                if (state is BookingLoaded) {
                  return TabBarView(
                    controller: tabController,
                    children: [
                      _buildBookingList(state.allBookings, 'pending'),
                      _buildBookingList(state.allBookings, 'completed'),
                      _buildBookingList(state.allBookings, 'cancelled'),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
