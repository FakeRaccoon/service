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

// const baseUrl = 'http://10.0.2.2:3000';
const baseUrl = 'http://192.168.5.114:3000';
const uploadUrl = 'http://192.168.5.114:4000';

const TIMEOUT_DURATION = 10 * 1000;

class APIService {
  final box = GetStorage();

  static var options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: TIMEOUT_DURATION,
    receiveTimeout: TIMEOUT_DURATION,
    sendTimeout: TIMEOUT_DURATION,
    receiveDataWhenStatusError: true,
  );
  static var options2 = BaseOptions(
    baseUrl: uploadUrl,
    connectTimeout: TIMEOUT_DURATION,
    receiveTimeout: TIMEOUT_DURATION,
    sendTimeout: TIMEOUT_DURATION,
    receiveDataWhenStatusError: true,
  );

  Dio dio = new Dio(options);
  Dio dio2 = new Dio(options2);

  Future _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future uploadImage(String path) async {
    try {
      var formData = FormData.fromMap({'image': await MultipartFile.fromFile(path)});
      final response = await dio2.post(uploadUrl, data: formData);
      return response.data;
    } on DioError catch (e) {
      throw e.message;
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
      final response = await dio.post(baseUrl + '/auth/token', data: {
        "token": '${box.read('refreshToken')}',
      });
      await box.write('token', response.data['token']);
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<User> userDetail() async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      final response = await dio.get(baseUrl + '/users/detail');
      return userFromJson(json.encode(response.data['result']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> logout() async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      await dio.post(baseUrl + '/auth/logout', data: {"token": box.read('refreshToken')});
      await box.erase();
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future getUser(String username) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      final response = await dio.get(baseUrl + '/users', queryParameters: {'username': username.trim()});
      if (response.data['result'] == null) {
        print(response.data);
      }
      print(response.data);
      return userFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<Order>> getOrder({int? fromStatus, int? toStatus, int? page}) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      final response = await dio.get(baseUrl + '/orders', queryParameters: {
        "page": page,
        "fromStatus": fromStatus,
        "toStatus": toStatus,
      });
      return orderFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<ItemModel>> getItem({String? search}) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      final response = await dio.get(
        baseUrl + '/items',
        queryParameters: {"search": search},
      );
      return itemFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<OrderDetail> getOrderDetail(int id) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      final response = await dio.get(baseUrl + '/orders/$id');
      return orderDetailFromJson(jsonEncode(response.data['result']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future updateOrder(
    int id, {
    DateTime? estimatedDate,
    String? problem,
    int? status,
    int? repairFee,
    int? dp,
    String? type,
  }) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      var formData = FormData();
      if (estimatedDate != null) formData.fields.add(MapEntry('estimated_date', '$estimatedDate'));
      if (repairFee != null) formData.fields.add(MapEntry('repair_fee', '$repairFee'));
      if (dp != null) formData.fields.add(MapEntry('dp', '$dp'));
      if (type != null) formData.fields.add(MapEntry('type', '$type'));
      if (problem != null) formData.fields.add(MapEntry('problem', '$problem'));
      if (status != null) formData.fields.add(MapEntry('status', '$status'));
      final response = await dio.put(baseUrl + '/orders/$id', data: formData);
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future updatePayment(int id, {double? dp}) async {
    try {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${box.read('token')}';
            return handler.next(options);
          },
          onError: (DioError err, handler) async {
            if (err.response?.statusCode == 401) {
              await refreshToken();
              return _retry(err.requestOptions);
            }
            return handler.next(err);
          },
        ),
      );
      dio.options.headers['Authorization'] = 'Bearer ${box.read('token')}';
      var formData = FormData();
      if (dp != null) formData.fields.add(MapEntry('dp', '$dp'));
      final response = await dio.put(baseUrl + '/payment/$id', data: formData);
      return response.data;
    } on DioError catch (e) {
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
      throw e.message;
    }
  }

  Future updateOrderItem(int id, {int? qty, int? price}) async {
    try {
      var formData = FormData();
      if (qty != null) formData.fields.add(MapEntry('qty', '$qty'));
      if (price != null) formData.fields.add(MapEntry('price', '$price'));
      final response = await dio.put(baseUrl + '/order-items/$id', data: formData);
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future deleteOrderItem(int id) async {
    try {
      final response = await dio.delete(baseUrl + '/order-items/$id');
      return response.data;
    } on DioError catch (e) {
      throw e.message;
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
      throw e.message;
    }
  }

  Future createOrder(
    String name,
    String address,
    int contact,
    String condition, {
    int? itemId,
    String? manualItem,
  }) async {
    try {
      final response = await dio.post(baseUrl + '/orders', data: {
        "name": name,
        "status": 0,
        "address": address,
        "contact": contact,
        "item_id": itemId,
        "manual_item": manualItem,
        "condition": condition,
      });
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
