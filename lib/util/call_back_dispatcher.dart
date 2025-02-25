import 'dart:convert';

import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "cacheRankingData") {
      final repository = VideoListRepository(); // ✅ Repository 초기화
      await cacheRankingData(repository); // ✅ 데이터를 가져오고 SharedPreferences에 캐싱
    }
    return Future.value(true);
  });
}

Future<void> cacheRankingData(VideoListRepository repository) async {
  try {
    final dailyRanking = await repository.fetchRanksDaily();
    final weeklyRanking = await repository.fetchRanksWeekly();

    // ✅ JSON 변환 후 SharedPreferences에 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("daily_ranking",
        jsonEncode(dailyRanking.map((e) => e.toJson()).toList()));
    prefs.setString("weekly_ranking",
        jsonEncode(weeklyRanking.map((e) => e.toJson()).toList()));
    prefs.setString("last_cache_time", DateTime.now().toIso8601String());

    print("✅ 랭킹 데이터 캐싱 완료!");
  } catch (e) {
    print("❌ 랭킹 데이터 캐싱 실패: $e");
  }
}
