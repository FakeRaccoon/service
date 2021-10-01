// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

List<ItemModel> itemFromJson(String str) => List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  ItemModel({
    this.id,
    this.itemCode,
    this.itemName,
    this.itemAlias,
    this.updatedAt,
  });

  int? id;
  String? itemCode;
  String? itemName;
  String? itemAlias;
  DateTime? updatedAt;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json["id"] == null ? null : json["id"],
    itemCode: json["item_code"] == null ? null : json["item_code"],
    itemName: json["item_name"] == null ? null : json["item_name"],
    itemAlias: json["item_alias"] == null ? null : json["item_alias"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "item_code": itemCode == null ? null : itemCode,
    "item_name": itemName == null ? null : itemName,
    "item_alias": itemAlias == null ? null : itemAlias,
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
