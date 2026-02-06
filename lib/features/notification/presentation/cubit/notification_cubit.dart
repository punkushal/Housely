import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/services/notification_service.dart';
import 'package:housely/features/notification/data/models/notification_model.dart';
import 'package:housely/injection_container.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = sl<NotificationService>();

  NotificationCubit() : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await _notificationService.getNotifications();
      emit(NotificationLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      await _notificationService.clearAllNotifications();
      emit(NotificationLoaded(notifications: []));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> deleteNotification(int id) async {
    if (state is NotificationLoaded) {
      final currentNotifications = (state as NotificationLoaded).notifications;
      try {
        await _notificationService.deleteNotification(id);
        final updatedNotifications = currentNotifications
            .where((n) => n.id != id)
            .toList();
        emit(NotificationLoaded(notifications: updatedNotifications));
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    }
  }
}
