import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/booking/domain/usecases/listen_booking_changes_use_case.dart';
import 'package:housely/features/booking/domain/usecases/request_booking_use_case.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  StreamSubscription? _subscription;
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
    final result = await requestBookingUseCase(RequestParam(event.booking));
    result.fold(
      (f) => emit(BookingFailure(f.message)),
      (_) => emit(BookingSuccess()),
    );
  }

  void _listenBookingChanges(
    ListenBookingChangesEvent event,
    Emitter<BookingState> emit,
  ) {
    _subscription = listenBookingChangesUseCase().listen((bookings) {
      emit(BookingLoaded(bookings));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
