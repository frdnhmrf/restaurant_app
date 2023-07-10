import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:restaurant_app/common/constants.dart';
import 'package:restaurant_app/data/models/requests/login_request_model.dart';
import 'package:restaurant_app/data/models/requests/register_request_model.dart';
import 'package:restaurant_app/data/models/responses/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthDataSource {
  Future<Either<String, AuthResponseModel>> register(
      RegisterRequestModel registerData) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/local/register'),
      body: jsonEncode(registerData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return const Left("API Error");
    }
  }

   Future<Either<String, AuthResponseModel>> login(
      LoginRequestModel model) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/auth/local/register'),
      body: jsonEncode(model.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Right(AuthResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return const Left("API Error");
    }
  }
}
