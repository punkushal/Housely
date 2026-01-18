import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/domain/usecases/listen_booking_changes_use_case.dart';
import 'package:housely/features/booking/domain/usecases/request_booking_use_case.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final RequestBookingUseCase requestBookingUseCase;
  final ListenBookingChangesUseCase listenBookingChangesUseCase;
  BookingBloc({
    required this.requestBookingUseCase,
    required this.listenBookingChangesUseCase,
  }) : super(BookingInitial()) {
    on<RequestBookingEvent>(_requestBooking);
    on<ListenBookingChangesEvent>(_listenBookingChanges);
  }

  Future<void> _requestBooking(
    RequestBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    await Future.delayed(const Duration(seconds: 2));
    final result = await requestBookingUseCase(RequestParam(event.booking));
    result.fold(
      (f) => emit(BookingFailure(f.message)),
      (_) => emit(BookingSuccess()),
    );
  }

  Future<void> _listenBookingChanges(
    ListenBookingChangesEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    await emit.forEach<List<BookingDetail>>(
      listenBookingChangesUseCase(),
      onData: (bookings) => BookingLoaded(bookings),
      onError: (error, stackTrace) => BookingFailure(error.toString()),
    );
  }
}
