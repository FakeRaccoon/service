// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.total,
    this.filteredData,
    this.perPage,
    this.currentPage,
    this.data,
  });

  int total;
  int filteredData;
  int perPage;
  int currentPage;
  List<Datum> data;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    total: json["total"] == null ? null : json["total"],
    filteredData: json["filtered_data"] == null ? null : json["filtered_data"],
    perPage: json["per_page"] == null ? null : json["per_page"],
    currentPage: json["current_page"] == null ? null : json["current_page"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total == null ? null : total,
    "filtered_data": filteredData == null ? null : filteredData,
    "per_page": perPage == null ? null : perPage,
    "current_page": currentPage == null ? null : currentPage,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.customer,
    this.item,
    this.status,
    this.problem,
    this.orderItems,
    this.payment,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  Customer customer;
  String item;
  int status;
  String problem;
  List<OrderItem> orderItems;
  Payment payment;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    item: json["item"] == null ? null : json["item"],
    status: json["status"] == null ? null : json["status"],
    problem: json["problem"] == null ? null : json["problem"],
    orderItems: json["order_items"] == null ? null : List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
    payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customer": customer == null ? null : customer.toJson(),
    "item": item == null ? null : item,
    "status": status == null ? null : status,
    "problem": problem == null ? null : problem,
    "order_items": orderItems == null ? null : List<dynamic>.from(orderItems.map((x) => x.toJson())),
    "payment": payment == null ? null : payment.toJson(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Customer {
  Customer({
    this.id,
    this.name,
    this.address,
    this.contact,
  });

  int id;
  String name;
  String address;
  int contact;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    address: json["address"] == null ? null : json["address"],
    contact: json["contact"] == null ? null : json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "address": address == null ? null : address,
    "contact": contact == null ? null : contact,
  };
}

class OrderItem {
  OrderItem({
    this.id,
    this.orderId,
    this.partsId,
    this.qty,
    this.price,
    this.total,
  });

  int id;
  int orderId;
  dynamic partsId;
  dynamic qty;
  dynamic price;
  dynamic total;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"] == null ? null : json["id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    partsId: json["parts_id"],
    qty: json["qty"],
    price: json["price"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "order_id": orderId == null ? null : orderId,
    "parts_id": partsId,
    "qty": qty,
    "price": price,
    "total": total,
  };
}

class Payment {
  Payment({
    this.id,
    this.repairFee,
    this.dp,
    this.type,
  });

  int id;
  int repairFee;
  dynamic dp;
  dynamic type;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"] == null ? null : json["id"],
    repairFee: json["repair_fee"] == null ? null : json["repair_fee"],
    dp: json["dp"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "repair_fee": repairFee == null ? null : repairFee,
    "dp": dp,
    "type": type,
  };
}
