// To parse this JSON data, do
//
//     final partsResult = partsResultFromJson(jsonString);

import 'dart:convert';

List<PartsResult> partsResultFromJson(String str) => List<PartsResult>.from(json.decode(str).map((x) => PartsResult.fromJson(x)));

String partsResultToJson(List<PartsResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PartsResult {
  PartsResult({
    this.id,
    this.formId,
    this.name,
    this.qty,
    this.price,
    this.selected,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? formId;
  String? name;
  int? qty;
  dynamic price;
  bool? selected;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PartsResult.fromJson(Map<String, dynamic> json) => PartsResult(
    id: json["id"],
    formId: json["form_id"],
    name: json["name"],
    qty: json["qty"],
    price: json["price"],
    selected: json["selected"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "form_id": formId,
    "name": name,
    "qty": qty,
    "price": price,
    "selected": selected,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
