import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:service/models/form.dart';
import 'package:service/models/item_model.dart';
import 'package:service/models/parts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static SharedPreferences sharedPreferences;
  static Future getForm(status) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    final url = 'http://10.0.2.2:8000/api/form';
    try {
      final response = await Dio().get(
        url,
        options: Options(headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}),
        queryParameters: {"status": status},
      );
      if (response.statusCode == 200) {
        final form = formResultFromJson(jsonEncode(response.data["result"]));
        return form;
      }
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  static Future formTotal(id, total) async {
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
    if (response.statusCode == 200) {
      final List items = itemResultFromJson(response.data);
      return items;
    }
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
