import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/domain/usecases/get_booking_request_list_use_case.dart';
import 'package:housely/features/booking/domain/usecases/listen_booking_changes_use_case.dart';
import 'package:housely/features/booking/domain/usecases/request_booking_use_case.dart';
import 'package:housely/features/booking/domain/usecases/respond_booking_use_case.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final RequestBookingUseCase requestBookingUseCase;
  final ListenBookingChangesUseCase listenBookingChangesUseCase;
  final RespondBookingUseCase respondBookingUseCase;
  final GetBookingRequestListUseCase getBookingRequestListUseCase;
  BookingBloc({
    required this.requestBookingUseCase,
    required this.listenBookingChangesUseCase,
    required this.respondBookingUseCase,
    required this.getBookingRequestListUseCase,
  }) : super(BookingInitial()) {
    on<RequestBookingEvent>(_requestBooking);
    on<LoadBookingRequestEvent>(_bookingRequestList);
    on<ResponseBookingRequestEvent>(_respondBookingRequest);
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

  Future<void> _respondBookingRequest(
    ResponseBookingRequestEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await respondBookingUseCase(
      RespondParams(bookingId: event.bookingId, status: event.status),
    );

    result.fold(
      (f) => emit(BookingFailure(f.message)),
      (_) => emit(BookingSuccess()),
    );
  }

  Future<void> _bookingRequestList(
    LoadBookingRequestEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await getBookingRequestListUseCase();

    result.fold(
      (f) => emit(BookingFailure(f.message)),
      (bookings) => emit(BookingLoaded(bookings)),
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
