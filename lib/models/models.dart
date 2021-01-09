// To parse this JSON data, do
//
//     final todos = todosFromJson(jsonString);

import 'dart:convert';

class Item {
  Item({
    this.itemId,
    this.itemName,
  });

  final double itemId;
  final String itemName;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json["itemId"] as double,
      itemName: json["itemName"] as String,
    );
  }
}
