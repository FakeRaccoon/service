// To parse this JSON data, do
//
//     final orderDetail = orderDetailFromJson(jsonString);

import 'dart:convert';

OrderDetail orderDetailFromJson(String str) => OrderDetail.fromJson(json.decode(str));

String orderDetailToJson(OrderDetail data) => json.encode(data.toJson());

class OrderDetail {
  OrderDetail({
    this.id,
    this.problem,
    this.status,
    this.estimatedDate,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.item,
    this.orderItems,
    this.payment,
  });

  int? id;
  String? problem;
  int? status;
  DateTime? estimatedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;
  Item? item;
  List<OrderItem>? orderItems;
  Payment? payment;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"] == null ? null : json["id"],
    problem: json["problem"] == null ? null : json["problem"],
    status: json["status"] == null ? null : json["status"],
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
    orderItems: json["order_items"] == null ? null : List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
    payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "problem": problem == null ? null : problem,
    "status": status == null ? null : status,
    "estimated_date": estimatedDate == null ? null : estimatedDate!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "customer": customer == null ? null : customer!.toJson(),
    "item": item == null ? null : item!.toJson(),
    "order_items": orderItems == null ? null : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    "payment": payment == null ? null : payment!.toJson(),
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

class OrderItem {
  OrderItem({
    this.id,
    this.price,
    this.qty,
    this.item,
  });

  int? id;
  int? price;
  int? qty;
  Item? item;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"] == null ? null : json["id"],
    price: json["price"] == null ? null : json["price"],
    qty: json["qty"] == null ? null : json["qty"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "price": price == null ? null : price,
    "qty": qty == null ? null : qty,
    "item": item == null ? null : item!.toJson(),
  };
}

class Payment {
  Payment({
    this.repairFee,
    this.dp,
    this.type,
  });

  int? repairFee;
  int? dp;
  String? type;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    repairFee: json["repair_fee"] == null ? null : json["repair_fee"],
    dp: json["dp"] == null ? null : json["dp"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "repair_fee": repairFee == null ? null : repairFee,
    "dp": dp == null ? null : dp,
    "type": type == null ? null : type,
  };
}
