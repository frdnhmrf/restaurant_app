import 'dart:convert';

import 'package:restaurant_app/data/models/responses/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<bool> saveAuthData(AuthResponseModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = prefs.setString('auth', jsonEncode(model.toJson()));
    return res;
  }

  Future<bool> removeAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = prefs.remove('auth');
    return res;
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth') ?? "";
    final model = AuthResponseModel.fromJson(jsonDecode(authData));
    return model.jwt;
  }

  Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth') ?? "";
    final model = AuthResponseModel.fromJson(jsonDecode(authData));
    return model.user.id;
  }

  Future<bool> isLogin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth') ?? "";
    return authData.isNotEmpty;
  }
}
