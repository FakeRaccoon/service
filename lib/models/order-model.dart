// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    this.id,
    this.problem,
    this.status,
    this.manualItem,
    this.condition,
    this.estimatedDate,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.item,
  });

  int? id;
  String? problem;
  int? status;
  String? manualItem;
  String? condition;
  DateTime? estimatedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;
  Item? item;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? null : json["id"],
    problem: json["problem"] == null ? null : json["problem"],
    status: json["status"] == null ? null : json["status"],
    manualItem: json["manual_item"] == null ? null : json["manual_item"],
    condition: json["condition"] == null ? null : json["manual_item"],
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customer: Customer.fromJson(json["customer"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "problem": problem == null ? null : problem,
    "manual_item": manualItem == null ? null : manualItem,
    "condition": condition == null ? null : condition,
    "status": status,
    "estimated_date": estimatedDate == null ? null : estimatedDate!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "customer": customer!.toJson(),
    "item": item == null ? null : item!.toJson(),
  };
}

class Customer {
  Customer({
    this.name,
    this.address,
    this.contact,
  });

  String? name;
  String? address;
  int? contact;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json["name"] == null ? null : json["name"],
    address: json["address"] == null ? null : json["address"],
    contact: json["contact"] == null ? null : json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "address": address == null ? null : address,
    "contact": contact == null ? null : contact,
  };
}

class Item {
  Item({
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

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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

