//   캐싱 데이터 로드 함수
import 'dart:convert';

import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/ranking/video_rank_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<VideoRankModel>? loadCachedRanking(SharedPreferences prefs, String key) {
  final cachedData = prefs.getString(key);
  if (cachedData != null) {
    final List<dynamic> jsonList = jsonDecode(cachedData);
    return jsonList.map((json) => VideoRankModel.fromJson(json)).toList();
  }
  return null;
}

//   캐싱 데이터 저장 함수
void cacheRanking(
    SharedPreferences prefs, String key, List<VideoRankModel> ranking) {
  final jsonData = jsonEncode(ranking.map((e) => e.toJson()).toList());
  prefs.setString(key, jsonData);
}

Future<VideoRankModel> getBestMovie() async {
  List<VideoRankModel> dailyRanking = [];
  final repository = VideoListRepository();
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0];

  final cachedDailyRanking = loadCachedRanking(prefs, 'daily_ranking_$today');

  if (cachedDailyRanking != null) {
    dailyRanking = cachedDailyRanking;
  } else {
    repository.fetchRanksDaily().then((data) {
      dailyRanking = data;
      cacheRanking(prefs, 'daily_ranking_$today', data);
    }).catchError((e) => print("Error fetching daily ranks: $e"));
  }

  print(dailyRanking);
  return dailyRanking[0];
}
