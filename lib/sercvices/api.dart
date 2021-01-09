import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service/models/form.dart';
import 'package:service/models/item_model.dart';
import 'package:service/models/parts_model.dart';

class API {
  static Future getForm() async {
    var url = 'http://10.0.2.2:8000/api/form';
    final response = await http.get(url, headers: {"status": "1"});
    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
      var parsed = json.encode(decode["data"]);
      final List form = formResultFromJson(parsed);
      print(parsed);
      return form;
    }
  }

  static Future getParts(id) async {
    var url = 'http://10.0.2.2:8000/api/parts';
    final response = await http.get(url, headers: {"form": "$id"});
    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
      var parsed = json.encode(decode["data"]);
      final List parts = partsResultFromJson(parsed);
      print(parsed);
      return parts;
    }
  }

  static Future getItems() async {
    var url = 'http://10.0.2.2:8000/api/items';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
      var parsed = json.encode(decode["data"]);
      final List items = itemResultFromJson(parsed);
      print(parsed);
      return items;
    }
  }

  static Future partsCreate(formId, name, qty) async {
    var url = 'http://10.0.2.2:8000/api/parts/create';
    final response = await http.post(url, body: {
      'form_id': "$formId",
      'name': "$name",
      'qty': "$qty",
      'selected': "false",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    print(response.body);
  }
}
