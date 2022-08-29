import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as timezone;
import 'package:timezone/data/latest.dart' as timezoneData;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  timezone.TZDateTime _nextInstanceOfTenAM() {
    final now = timezone.TZDateTime.now(timezone.local);
    var scheduledDate =
        timezone.TZDateTime(timezone.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  timezone.TZDateTime _nextInstanceOfMondayTenAM() {
    var scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> init() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings(requestSoundPermission: true);

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin.initialize(initSettings);
  }

  void notify(
    String title,
    String body,
    int id,
    int endTime, {
    String sound = '',
    String channel = 'default',
    DateTimeComponents matchDateTime = DateTimeComponents.time,
  }) async {
    timezoneData.initializeTimeZones();

    final scheduleTime =
        timezone.TZDateTime.fromMillisecondsSinceEpoch(timezone.local, endTime);

    final iosDetail = sound == ''
        ? null
        : IOSNotificationDetails(presentSound: true, sound: sound);

    final soundFile = sound.replaceAll('.mp3', '');
    final notificationSound =
        sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final androidDetail = AndroidNotificationDetails(channel, channel,
        playSound: true, sound: notificationSound);

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: matchDateTime,
    );
  }

  void notifyMonthly(
    String title,
    String body,
    int id, {
    String sound = '',
    String channel = 'monthly_deworm',
  }) async {
    timezoneData.initializeTimeZones();

    final iosDetail = sound == ''
        ? null
        : IOSNotificationDetails(presentSound: true, sound: sound);

    final soundFile = sound.replaceAll('.mp3', '');
    final notificationSound =
        sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final androidDetail = AndroidNotificationDetails(channel, channel,
        playSound: true, sound: notificationSound);

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfMondayTenAM(),
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  void cancelAll() {
    _localNotificationsPlugin.cancelAll();
  }
}
