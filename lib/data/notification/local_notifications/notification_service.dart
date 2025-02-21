import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized ;

  Future<void>initNotification() async {
    if (_isInitialized) return;

    const initSettingAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettingIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
        android: initSettingAndroid,
        iOS: initSettingIos
    );

    await notificationsPlugin.initialize(initSettings);
  }

  // In your NotiService class, update these methods:

// Add explicit configuration for Android
  AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notification',
      channelDescription: 'Daily Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: _androidDetails(),
      iOS: DarwinNotificationDetails(
        // Add iOS-specific non-null parameters
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

// Update showNotification to use proper details
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }
}
