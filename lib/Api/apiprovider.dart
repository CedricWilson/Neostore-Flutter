import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_neostore/Modal/ResponseBuy.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';
import 'package:flutter_neostore/Modal/ResponseDetails.dart';
import 'package:flutter_neostore/Modal/ResponseLogin.dart';
import 'package:flutter_neostore/Modal/ResponseOrder.dart';
import 'package:flutter_neostore/Modal/ResponseOrderDetail.dart';
import 'package:flutter_neostore/Modal/ResponseProduct.dart';
import 'package:flutter_neostore/Modal/ResponseRegistration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final String _base = "http://staging.php-dev.in:8844/trainingapp/api/";
  Dio _dio;

  ApiProvider() {
    BaseOptions options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    _dio = Dio(options);
  }

  Future<String> rate(int id, int rating) async {

    String append = "products/setRating";
    FormData formData = new FormData.fromMap({
      "product_id": id,
      "rating": rating,
    });
    try {
      Response response = await _dio.post(
        _base + append,
        data: formData,
      );
      var parsed = json.decode(response.data);
      return parsed['user_msg'];
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseOrderDetail> orderdetail(String id) async {
    String append = "orderDetail";
    String token = await SharedPrefs().token();
    try {
      Response response = await _dio.get(_base + append,
          options: Options(
            headers: {"access_token": token},
          ),
          queryParameters: {"order_id": id});
      var parsed = json.decode(response.data);
      return ResponseOrderDetail.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);

      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseOrder> orderlist() async {
    String append = "orderList";
    String token = await SharedPrefs().token();
    try {
      Response response = await _dio.get(
        _base + append,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      return ResponseOrder.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<int> order(String address, String token) async {
    String append = "order";

    FormData formData = new FormData.fromMap({
      "address": address,
    });
    try {
      Response response = await _dio.post(
        _base + append,
        data: formData,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      print("Api: " + parsed['status'].toString());
      return parsed['status'];
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<int> cartupdate(int id, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String test1 = id.toString();
    String test2 = quantity.toString();

    String append = "editCart";
    FormData formData = new FormData.fromMap({
      "product_id": test1,
      "quantity": test2,
    });
    try {
      Response response = await _dio.post(
        _base + append,
        data: formData,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      return parsed['status'];
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<String> delete(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    String append = "deleteCart";
    FormData formData = new FormData.fromMap({
      "product_id": id,
    });
    try {
      Response response = await _dio.post(
        _base + append,
        data: formData,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      return parsed['user_msg'];
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseCart> cart() async {
    String append = "cart";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      Response response = await _dio.get(
        _base + append,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      // print("Response: " + parsed['user_msg']);
      return ResponseCart.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseBuy> buy(String token, String id, String quantity) async {
    String append = "addToCart";
    //print(_base+append);
    FormData formData = new FormData.fromMap({
      "product_id": id,
      "quantity": quantity,
    });
    try {
      Response response = await _dio.post(
        _base + append,
        data: formData,
        options: Options(
          headers: {"access_token": token},
        ),
      );
      var parsed = json.decode(response.data);
      // print("Response: " + parsed['user_msg']);
      return ResponseBuy.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);
      print("DIO: " + e.response.data.toString());
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseDetails> details(int id) async {
    String append = "products/getDetail";
    //print(_base+append);
    try {
      Response response = await _dio.get(_base + append, queryParameters: {"product_id": id});
      // print(response.data[10]);
      var parsed = json.decode(response.data);
      // print("Response: " + parsed['data']['name'].toString());
      return ResponseDetails.fromJson(parsed);
    } on DioError catch (e) {
      // print("Message: "+e.message);
      print("DioError: " + e.response.statusMessage);
      var parsed = json.decode(e.response.data);
      throw e.message;
    }
  }

  Future<ResponseProduct> product(String id) async {
    String append = "products/getList";
    //print(_base+append);
    try {
      Response response = await _dio.get(_base + append, queryParameters: {"product_category_id": id});
      // print(response.data[10]);
      var parsed = json.decode(response.data);
      //print("Response: " + parsed['status'].toString());
      return ResponseProduct.fromJson(parsed);
    } on DioError catch (e) {
      // print("Message: "+e.message);
      print("DioError: " + e.response.statusMessage);
      var parsed = json.decode(e.response.data);
      throw e.message;
    }
  }

  Future<ResponseRegistration> register(String fname, String lname, String email, String password, String confirm,
      String phone, String gender) async {
    String append = "users/register";
    //print(_base+append);
    FormData formData = new FormData.fromMap({
      "first_name": fname,
      "last_name": lname,
      "email": email,
      "gender": gender,
      "password": password,
      "confirm_password": confirm,
      "phone_no": phone,
    });
    try {
      Response response = await _dio.post(_base + append, data: formData);
      var parsed = json.decode(response.data);
      print("Response: " + parsed['user_msg']);
      return ResponseRegistration.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);
      //print(e.response.data);
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }

  Future<ResponseLogin> login(String email, String password) async {
    String append = "users/login";
    //print(_base+append);
    FormData formData = new FormData.fromMap({
      "email": email,
      "password": password,
    });
    try {
      Response response = await _dio.post(_base + append, data: formData);
      var parsed = json.decode(response.data);
      // print("Response: " + parsed['user_msg']);
      return ResponseLogin.fromJson(parsed);
    } on DioError catch (e) {
      print(e.message);
      var parsed = json.decode(e.response.data);
      throw parsed["user_msg"];
    }
  }
}
