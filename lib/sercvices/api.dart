import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:service/models/order-model.dart';
import 'package:service/models/parts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const APIUrl = 'http://10.0.2.2:8000';

class APIService {
  static SharedPreferences sharedPreferences;

  var options = BaseOptions(
    baseUrl: '$APIUrl/api',
    connectTimeout: 10 * 1000,
    receiveTimeout: 10 * 1000,
    sendTimeout: 10 * 1000,
    receiveDataWhenStatusError: true,
  );

  Future login(username, password) async {
    final url = '$APIUrl/api/login';
    try {
      final response = await Dio().post(
        url,
        data: {"username": username, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final url = '$APIUrl/api/logout';
      final response = await Dio().post(url, options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.data;
    }
  }

  Future getOrder<OrderModel>(page, status) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    Dio dio = Dio(options);
    try {
      final response = await dio.post(
        'http://10.0.2.2:8000/api/get-order?page=$page',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {"status": null},
      );
      print(response.data);
      return orderModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw 'Connection Timeout';
      } else if (e.type == DioErrorType.other) {
        throw 'No Internet';
      } else {
        print(e.response.data);
        throw e.response.statusMessage;
      }
    }
  }

  Future createOrder(item, problem) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final url = '$APIUrl/api/order-create';
    Dio dio = Dio(options);
    try {
      final response = await dio.post(url,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          data: {
            "status": 0,
            "item": item,
            "problem": problem,
          });
      return response.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw 'Connection Timeout';
      } else if (e.type == DioErrorType.other) {
        throw 'No Internet';
      } else {
        throw e.response.statusMessage;
      }
    }
  }

  Future createCustomer(orderId, name, address, contact) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Dio dio = Dio(options);
    final token = sharedPreferences.getString('token');
    final url = '$APIUrl/api/customer-create';
    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}),
        data: {
          "order_id": orderId,
          "name": name,
          "address": address,
          "contact": contact,
        },
      );
      return response.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw 'Connection Timeout';
      } else if (e.type == DioErrorType.other) {
        throw 'No Internet';
      } else {
        throw e.response.statusMessage;
      }
    }
  }

  Future formTotal(id, total) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      var url = 'http://10.0.2.2:8000/api/form/update/total';
      final response = await Dio().post(
        url,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }),
        queryParameters: {"id": id, "total": total},
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  static Future getParts(id) async {
    var url = 'http://10.0.2.2:8000/api/parts';
    final response = await Dio().get(url, queryParameters: {"form": "$id"});
    if (response.statusCode == 200) {
      var decode = json.decode(response.data);
      var parsed = json.encode(decode["data"]);
      final List parts = partsResultFromJson(parsed);
      print(parsed);
      return parts;
    }
  }

  static Future getItems() async {
    var url = 'http://10.0.2.2:8000/api/items';
    final response = await Dio().get(url);
    if (response.statusCode == 200) {}
  }

  static Future partsUpdate(id, price) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    var url = 'http://10.0.2.2:8000/api/parts/update';
    try {
      final response = await Dio().post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'id': id,
          'price': price,
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  static Future formFeeUpdate(id, fee) async {
    var url = "http://10.0.2.2:8000/api/form/update/fee/$id";
    try {
      final response = await Dio()
          .post(url, queryParameters: {"Content-Type": "application/json"}, data: jsonEncode({"final_fee": fee}));
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future formRepairStatusUpdate(id, int repair) async {
    var url = "http://10.0.2.2:8000/api/form/update/repair/$id";
    try {
      final response = await Dio().post(url,
          queryParameters: {"Content-Type": "application/json"},
          data: jsonEncode({
            "repair_process": repair,
          }));
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future formStatusUpdate(id, status) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    var url = "http://10.0.2.2:8000/api/form/update/status";
    try {
      final response = await Dio().post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
        queryParameters: {'id': id, "status": status},
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }
}
