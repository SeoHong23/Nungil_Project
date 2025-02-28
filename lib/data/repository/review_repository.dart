import 'package:nungil/models/review/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReviewRepository{


  final String baseUR = 'http://13.239.238.92:8080';

  Future <Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token')?? '';

    return {
      'Content-Type' : 'application/json',
      'Authorization' : token.isNotEmpty ? 'Bearer $token' :'',
    };
  }





}