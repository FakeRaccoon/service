import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service/models/form.dart';
import 'package:service/models/item_model.dart';
import 'package:service/models/parts_model.dart';

class API {
  static Future getForm(status) async {
    var url = 'http://10.0.2.2:8000/api/form';
    try {
      final response = await http.get(url, headers: {
        "status": "$status",
      });
      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        var parsed = json.encode(decode["data"]);
        final List form = formResultFromJson(parsed);
        print(parsed);
        return form;
      }
    } on Exception catch (e) {
      print(e); // TODO
    }
  }

  static Future formCreate(customer, item) async {
    var url = 'http://10.0.2.2:8000/api/form/create';
    final response = await http.post(
      url,
      body: {"customer": "$customer", "item": "$item", "status": "1", "receipt_date": DateTime.now().toString()},
    );
    try {
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future formUpdate(id, estimatedDate, estimatedFee) async {
    var url = 'http://10.0.2.2:8000/api/form/update/$id';
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "estimated_date": "$estimatedDate",
        "estimated_fee": "$estimatedFee",
        "status": 2,
      }),
    );
    try {
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future formTotal(id, total) async {
    var url = 'http://10.0.2.2:8000/api/form/update/total/$id';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"total": total}),
      );
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
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
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'form_id': formId,
            'name': name,
            'qty': qty,
          }));
      if (response.statusCode == 200) {
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future partsUpdate(id, price) async {
    var url = 'http://10.0.2.2:8000/api/parts/update/$id';
    final response = await http.post(url, body: {
      'price': "$price",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    print(response.body);
  }

  static Future formFeeUpdate(id, fee) async {
    var url = "http://10.0.2.2:8000/api/form/update/fee/$id";
    try {
      final response =
          await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode({"final_fee": fee}));
      if (response.statusCode == 200) {
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future formRepairStatusUpdate(id, int repair) async {
    var url = "http://10.0.2.2:8000/api/form/update/repair/$id";
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "repair_process": repair,
          }));
      if (response.statusCode == 200) {
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future formStatusUpdate(id, int status) async {
    var url = "http://10.0.2.2:8000/api/form/update/status/$id";
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
        print(response.body);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
