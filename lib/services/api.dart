import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as route;
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/models/part-model.dart';
import 'package:service/models/parts_model.dart';
import 'package:service/models/user-model.dart';
import 'package:service/root.dart';
import 'package:service/screens/home.dart';
import 'package:service/screens/responsive-login-page.dart';
import 'package:service/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// const BaseUrl = 'http://10.0.2.2:8000';
const baseUrl = 'http://127.0.0.1:3000';

const TIMEOUT_DURATION = 10 * 1000;

class APIService {
  final box = GetStorage();

  static var options = BaseOptions(
    baseUrl: '$baseUrl',
    connectTimeout: TIMEOUT_DURATION,
    receiveTimeout: TIMEOUT_DURATION,
    sendTimeout: TIMEOUT_DURATION,
    receiveDataWhenStatusError: true,
  );

  Dio dio = Dio(options);

  Future getToken() async {
    print('Refresh Token Called');
    try {
      final response = await dio.post(baseUrl + '/auth/token', data: {
        "token": '${box.read('refreshToken')}',
      });
      await box.write('token', response.data['token']);
      refreshToken();
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future login(username, password) async {
    try {
      final response = await dio.post(baseUrl + '/auth/login', data: {
        "username": username,
        'password': password,
      });
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> refreshToken() async {
    try {
      final refresh = await dio.post(baseUrl + '/auth/token', data: {
        "token": '${box.read('refreshToken')}',
      });
      await box.write('token', refresh.data['token']);
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future authCheck() async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(InterceptorsWrapper(onError: (DioError error, handler) async {
        if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
          try {
            await refreshToken().then((value) async {
              error.requestOptions.headers["Authorization"] = "Bearer " + box.read('token');
              final opts = new Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );
              final cloneReq = await dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(cloneReq);
            });
          } catch (e) {
            // TODO
          }
        }
      }));
      route.Get.offAllNamed('/home');
    } on DioError {
      route.Get.offAllNamed('/login');
    }
  }

  Future<User> userDetail() async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(InterceptorsWrapper(onError: (DioError error, handler) async {
        if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
          try {
            await refreshToken().then((value) async {
              error.requestOptions.headers["Authorization"] = "Bearer " + box.read('token');
              final opts = new Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );
              final cloneReq = await dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(cloneReq);
            });
          } catch (e) {
            // TODO
          }
        }
      }));
      dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
      final refresh = await dio.get(baseUrl + '/users/detail');
      return userFromJson(jsonEncode(refresh.data['result']));
    } on DioError catch (e) {
      print(e.response?.statusCode);
      throw e.message;
    }
  }

  Future<void> logout() async {
    try {
      await dio.post(baseUrl + '/auth/logout', data: {"token": box.read('refreshToken')});
      await box.erase();
      route.Get.offAllNamed('/login');
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future getUser(String username) async {
    try {
      final response = await dio.get(baseUrl + '/users', queryParameters: {'username': username.trim()});
      if (response.data['result'] == null) {
        print(response.data);
      }
      print(response.data);
      return userFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future<List<Order>> getOrder({int? status, int? page}) async {
    try {
      final response = await dio.get(baseUrl + '/orders', queryParameters: {"page": page, "status": status});
      return orderFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
      throw e.message;
    }
  }

  Future<List<ItemModel>> getItem({String? search}) async {
    try {
      final response = await dio.get(
        baseUrl + '/items',
        queryParameters: {"search": search},
      );
      return itemFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
      throw e.message;
    }
  }

  Future<OrderDetail> getOrderDetail(int id) async {
    try {
      final response = await dio.get(baseUrl + '/orders/$id');
      return orderDetailFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
      throw e.message;
    }
  }

  Future createOrderItem(int orderId, int itemId) async {
    try {
      final response = await dio.post(baseUrl + '/order-items', data: {
        "order_id": orderId,
        "item_id": itemId,
      });
      return response.data;
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future updateOrderItemQty(int id, int qty) async {
    try {
      final response = await dio.put(baseUrl + '/order-items/$id', data: {"qty": qty});
      return response.data;
    } on DioError catch (e) {
      print(e);
      ErrorHandling.throwError(e);
    }
  }

  Future updateOrderItemPrice(int id, int price) async {
    try {
      final response = await dio.put(baseUrl + '/order-items/$id', data: {"price": price});
      return response.data;
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future deleteOrderItem(int id) async {
    try {
      final response = await dio.delete(baseUrl + '/order-items/$id');
      return response.data;
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future createPart(String name) async {
    final url = '$baseUrl/part';
    try {
      final response = await dio.post(url, data: {
        "name": name,
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future createOrder(String name, String address, int contact, int itemId) async {
    try {
      final response = await dio.post(baseUrl + '/orders', data: {
        "name": name,
        "status": 0,
        "address": address,
        "contact": contact,
        "item_id": itemId,
      });
      return response.data;
    } on DioError catch (e) {
      ErrorHandling.throwError(e);
    }
  }

  Future updateOrder(int id, {DateTime? estimatedDate, String? problem, int? status}) async {
    try {
      var formData = FormData();
      if (estimatedDate != null) formData.fields.add(MapEntry('estimated_date', '$estimatedDate'));
      if (problem != null) formData.fields.add(MapEntry('problem', '$problem'));
      if (status != null) formData.fields.add(MapEntry('status', '$status'));
      final response = await dio.put(baseUrl + '/orders/$id', data: {"estimated_date": estimatedDate.toString()});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e);
      ErrorHandling.throwError(e);
    }
  }
}
