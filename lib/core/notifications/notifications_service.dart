import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(initSettings);
  }

  Future<void> showStepChange(int stepIndex, {String? title, String? body}) async {
    if (Platform.isAndroid) {
      const details = AndroidNotificationDetails(
        'session_steps',
        'Session Steps',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      await _plugin.show(100 + stepIndex, title ?? 'Next position', body ?? 'Move to next position', const NotificationDetails(android: details));
    } else {
      const details = DarwinNotificationDetails(presentSound: true);
      await _plugin.show(100 + stepIndex, title ?? 'Next position', body ?? 'Move to next position', const NotificationDetails(iOS: details));
    }
  }
}


