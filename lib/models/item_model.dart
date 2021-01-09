// To parse this JSON data, do
//
//     final itemResult = itemResultFromJson(jsonString);

import 'dart:convert';

List<ItemResult> itemResultFromJson(String str) => List<ItemResult>.from(json.decode(str).map((x) => ItemResult.fromJson(x)));

String itemResultToJson(List<ItemResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemResult {
  ItemResult({
    this.id,
    this.item,
    this.selected,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String item;
  bool selected;
  DateTime createdAt;
  DateTime updatedAt;

  factory ItemResult.fromJson(Map<String, dynamic> json) => ItemResult(
    id: json["id"],
    item: json["item"],
    selected: json["selected"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "selected": selected,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
