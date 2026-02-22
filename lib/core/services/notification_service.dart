import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

@singleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(initSettings);

    await _setupNotificationChannel();

    _initialized = true;
  }

  Future<void> _setupNotificationChannel() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      await android.deleteNotificationChannel('race_reminders');

      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          'race_reminders',
          'Race Reminders',
          description: 'Notifications for upcoming F1 races',
          importance: Importance.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
      );
    }
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      return false;
    }

    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final macos = _notifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();

    bool granted = false;

    if (android != null) {
      granted = await android.requestNotificationsPermission() ?? false;
      await android.requestExactAlarmsPermission();
    }
    if (ios != null) {
      granted =
          await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          granted;
    }
    if (macos != null) {
      granted =
          await macos.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          granted;
    }

    return granted;
  }

  Future<bool> _canScheduleExactAlarms() async {
    if (kIsWeb) return false;

    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    return await android?.canScheduleExactNotifications() ?? false;
  }

  Future<void> scheduleRaceReminder({
    required int id,
    required String raceName,
    required DateTime raceTime,
    int minutesBefore = 30,
  }) async {
    if (kIsWeb) {
      return;
    }

    final scheduledTime = raceTime.subtract(Duration(minutes: minutesBefore));

    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }

    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
    final canUseExactAlarms = await _canScheduleExactAlarms();

    await _notifications.zonedSchedule(
      id,
      'Race Starting Soon!',
      '$raceName starts in $minutesBefore minutes',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'race_reminders',
          'Race Reminders',
          channelDescription: 'Notifications for upcoming F1 races',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/launcher_icon',
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification.mp3',
        ),
      ),
      androidScheduleMode: canUseExactAlarms
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingReminders() async {
    return await _notifications.pendingNotificationRequests();
  }
}
