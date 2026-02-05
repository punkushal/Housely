import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';
import 'package:housely/injection_container.dart';
import 'dart:convert';

import '../../app/app_router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `Firebase.initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Set background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

    // Foreground Message Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    // Background Message Handler (App Opened)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundNotificationClick(message);
    });

    // Terminated Message Handler
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundNotificationClick(initialMessage);
    }
  }

  void _showForegroundNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Create payload with required data for navigation
      final payloadData = {
        'chatId': message.data['chatId'],
        'senderId': message.data['senderId'],
      };

      // Ensure unique ID for each notification
      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        id: notificationId,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode(payloadData),
      );
    }
  }

  void _handleNotificationClick(String? payload) async {
    if (payload != null) {
      try {
        final data = jsonDecode(payload);
        final String? chatId = data['chatId'];
        final String? senderId = data['senderId'];

        if (chatId != null && senderId != null) {
          // Fetch Current User
          final authRepo = sl<AuthRepo>();
          final currentUserResult = await authRepo.getCurrentUser();

          // Fetch Other User (Sender)
          final chatRepo = sl<ChatRepository>();
          final otherUserResult = await chatRepo.getUserDetails(senderId);

          ChatUser? currentUserEntity;
          ChatUser? otherUserEntity;

          // Handle Current User Result
          currentUserResult.fold((failure) => null, (user) {
            if (user != null) {
              // Extracting image url safely from map if present
              Map<String, dynamic>? profileImage;
              if (user.profileImage != null &&
                  user.profileImage!.containsKey('url')) {
                profileImage = user.profileImage!['url'];
              }

              currentUserEntity = ChatUser(
                uid: user.uid,
                name: user.username,
                email: user.email,
                profileImage: profileImage,
              );
            }
          });

          // Handle Other User Result
          otherUserResult.fold(
            (failure) => null,
            (user) => otherUserEntity = user,
          );

          // Navigate if both users are available
          if (currentUserEntity != null && otherUserEntity != null) {
            sl<AppRouter>().push(
              ChatRoute(
                currentUser: currentUserEntity!,
                otherUser: otherUserEntity!,
              ),
            );
          }
        }
      } catch (e) {
        // Log error
        debugPrint("Error navigating to chat: $e");
      }
    }
  }

  void _handleBackgroundNotificationClick(RemoteMessage message) {
    if (message.data.containsKey('chatId')) {
      final payload = jsonEncode({
        'chatId': message.data['chatId'],
        'senderId': message.data['senderId'],
      });
      _handleNotificationClick(payload);
    }
  }
}
