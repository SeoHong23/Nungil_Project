import 'package:nungil/models/user/setting_model.dart';
import 'package:nungil/notification/notification.dart';
import 'package:nungil/util/call_back_dispatcher.dart';
import 'package:nungil/util/my_http.dart';

class SettingRepository {
  const SettingRepository();

  Future<bool> getAlert(int id) async {
    final response = await dio.get('/api/setting?userId=$id');

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        if (SettingModel.fromJson(response.data).isAlert == "0") {
          return false;
        } else {
          return true;
        }
        ;
      } else {
        throw const FormatException("Invalid response format: expected a map.");
      }
    } else {
      throw Exception(
          "Failed to fetch setting data. Status code: ${response.statusCode}");
    }
  }

  Future<void> setAlert(int id, bool isAlert) async {
    String alert = '';
    if (isAlert) {
      alert = '1';
      FlutterLocalNotification.requestNotificationPermission();
      scheduleWorkManagerDailyNotification(
        12,
        00,
      );
    } else {
      alert = '0';
      FlutterLocalNotification.cancelAllNotification();
    }
    final response =
        await dio.put('/api/setting?userId=$id', data: {"isAlert": alert});

    if (response.statusCode == 200) {
    } else {
      throw Exception(
          "Failed to fetch setting data. Status code: ${response.statusCode}");
    }
  }
}
