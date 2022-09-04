import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  void init() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'feed_channel_group',
              channelKey: 'feed_channel',
              channelName: 'Feed notifications',
              channelDescription: 'Notification channel for feeds',
              defaultColor: Colors.indigo,
              ledColor: Colors.red),
          NotificationChannel(
              channelGroupKey: 'drug_channel_group',
              channelKey: 'drug_channel',
              channelName: 'Drug administration notifications',
              channelDescription:
                  'Notification channel for drug administrations',
              defaultColor: Colors.pink,
              ledColor: Colors.green)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'feed_channel_group',
              channelGroupName: 'Feed group'),
          NotificationChannelGroup(
              channelGroupkey: 'drug_channel_group',
              channelGroupName: 'Drug group')
        ],
        debug: true);
  }

  void requestNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> notify(
    String title,
    String body, {
    required String channel,
    int? id,
    required int time,
  }) async {
    final localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            wakeUpScreen: true,
            category: NotificationCategory.Reminder,
            id: id ?? 10,
            channelKey: channel,
            title: title,
            body: body),
        schedule: NotificationInterval(
            interval: (60 * 60 * 24) - (time * 60),
            timeZone: localTimeZone,
            allowWhileIdle: true,
            repeats: true));
  }
}
