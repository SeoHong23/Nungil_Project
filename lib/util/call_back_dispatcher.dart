import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/ranking/video_rank_model.dart';
import 'package:nungil/screens/home/components/rank_management.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;

void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      try {
        if (task == "cacheRankingData") {
          final repository = VideoListRepository(); //   Repository 초기화
          await cacheRankingData(
              repository); //   데이터를 가져오고 SharedPreferences에 캐싱
        }

        // 타임존 초기화
        tz.initializeTimeZones();
        tz.setLocalLocation(
            tz.getLocation('Asia/Seoul')); // 한국 타임존 또는 해당하는 지역 타임존

        // 알림 플러그인 초기화
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(),
          ),
        );

        // 알림 세부 설정
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'workmanager_channel',
          'WorkManager Notifications',
          channelDescription: 'Notifications triggered by WorkManager',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true,
        );

        const NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: DarwinNotificationDetails(badgeNumber: 1),
        );

        // 작업 유형에 따라 처리
        if (task == 'scheduledDailyNotification') {
          String title = '🍿오늘의 인기 영화 1위는?';
          int notificationId = inputData?['id'] ?? 0;
          VideoRankModel best = await getBestMovie();
          // 즉시 알림 표시
          await flutterLocalNotificationsPlugin.show(
            notificationId,
            title,
            best.title,
            notificationDetails,
          );
        }

        return Future.value(true);
      } catch (e) {
        print('WorkManager 작업 실행 실패: $e');
        return Future.value(false);
      }
    },
  );
}

Future<void> cacheRankingData(VideoListRepository repository) async {
  try {
    final dailyRanking = await repository.fetchRanksDaily();
    final weeklyRanking = await repository.fetchRanksWeekly();

    //   JSON 변환 후 SharedPreferences에 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("daily_ranking",
        jsonEncode(dailyRanking.map((e) => e.toJson()).toList()));
    prefs.setString("weekly_ranking",
        jsonEncode(weeklyRanking.map((e) => e.toJson()).toList()));
    prefs.setString("last_cache_time", DateTime.now().toIso8601String());

    print("  랭킹 데이터 캐싱 완료!");
  } catch (e) {
    print("  랭킹 데이터 캐싱 실패: $e");
  }
}

Future<void> scheduleWorkManagerDailyNotification(int hour, int minute) async {
  // 현재 날짜 및 시간 가져오기
  final now = DateTime.now();
  final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

  // 이미 지난 시간이면 다음 날로 설정
  final initialDelay = scheduledTime.isAfter(now)
      ? scheduledTime.difference(now)
      : scheduledTime.add(Duration(days: 1)).difference(now);

  // 초 단위로 변환
  final initialDelaySeconds = initialDelay.inSeconds;

  try {
    // 기존 작업 취소 (동일한 태그가 있는 경우)
    await Workmanager().cancelByTag('daily_notification');

    // 첫 번째 실행을 위한 일회성 작업 등록
    await Workmanager().registerOneOffTask(
      'one_off_task_${DateTime.now().millisecondsSinceEpoch}',
      'scheduledDailyNotification',
      tag: 'daily_notification',
      initialDelay: Duration(seconds: initialDelaySeconds),
      inputData: {
        'id': 3,
      },
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // 매일 반복되는 주기적 작업 등록
    await Workmanager().registerPeriodicTask(
      'periodic_task_daily',
      'scheduledDailyNotification',
      tag: 'daily_notification_periodic',
      frequency: Duration(days: 1),
      initialDelay:
          Duration(seconds: initialDelaySeconds + 86400), // 첫 번째 실행 후 다음 날 실행
      inputData: {
        'id': 3,
      },
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  } catch (e) {}
}
