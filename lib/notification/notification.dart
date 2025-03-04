import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    // 타임존 데이터 초기화
    tz.initializeTimeZones();

    // 기본 타임존을 수동으로 설정 (예: Asia/Seoul)
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> initializeTimezone() async {
    tz.initializeTimeZones(); // 시간대 데이터를 초기화
    // tz.setLocalLocation(tz.getLocation(timeZoneName)); // 로컬 시간대 설정
  }

  static const NotificationDetails details = NotificationDetails(
    android: AndroidNotificationDetails(
      'Nungil_notification_channel', // 채널 ID
      'Nungil Notifications', // 채널 이름
      channelDescription: '푸시 알림의 설명',
      importance: Importance.max, // 중요도 (보통 설정)
      priority: Priority.max, // 우선순위 (보통 설정)
      playSound: true, // 소리 재생 여부
      enableVibration: true, // 진동 사용 여부
      showWhen: false,
    ),
    iOS: DarwinNotificationDetails(
      sound: 'default', // iOS 알람 소리
    ),
  );

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
