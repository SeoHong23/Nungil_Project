import 'package:workmanager/workmanager.dart';

void scheduleDailyCacheUpdate() {
  Workmanager().registerPeriodicTask(
    "daily_ranking_cache", // 작업 식별자 (고유해야 함)
    "cacheRankingData", // 실행할 작업 이름
    frequency: Duration(hours: 24), // 매일 실행
    constraints: Constraints(
      networkType: NetworkType.connected, // 네트워크 연결 필요
      requiresBatteryNotLow: true, // 배터리 부족 시 실행 안 함
      requiresCharging: true, // 충전 중일 때만 실행
    ),
    initialDelay: Duration(hours: 4), // 새벽 4시에 실행
  );
}
