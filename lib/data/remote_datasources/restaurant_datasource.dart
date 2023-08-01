import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:restaurant_app/common/constants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/local_datasources/auth_local_datasource.dart';
import 'package:restaurant_app/data/models/requests/add_product_request_model.dart';
import 'package:restaurant_app/data/models/responses/add_product_response_model.dart';
import 'package:restaurant_app/data/models/responses/products_response_model.dart';

class RestaurantDataSource {
  Future<Either<String, ProductsResponseModel>> getAll() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/restaurants'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        ProductsResponseModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    } else {
      return const Left('Gagal mengambil data');
    }
  }

  Future<Either<String, AddProductResponseModel>> getById(int id) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/restaurants/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        AddProductResponseModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    } else {
      return const Left('Gagal mengambil data');
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct(
      AddProductRequestModel addProductData) async {
    final token = await AuthLocalDataSource().getToken();
    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/restaurants"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "Autorization": "Bearer $token"
      },
      body: jsonEncode(addProductData.toJson()),
    );

    if (response.statusCode == 200) {
      return Right(AddProductResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return const Left("Gagal membuat data");
    }
  }

  Future<Either<String, ProductsResponseModel>> getByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/restaurants?filters[userId]=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        ProductsResponseModel.fromJson(
          jsonDecode(response.body),
        ),
      );
    } else {
      return const Left('Gagal mengambil data');
    }
  }
}
