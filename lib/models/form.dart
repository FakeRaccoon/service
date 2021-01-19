// To parse this JSON data, do
//
//     final formResult = formResultFromJson(jsonString);

import 'dart:convert';

List<FormResult> formResultFromJson(String str) => List<FormResult>.from(json.decode(str).map((x) => FormResult.fromJson(x)));

String formResultToJson(List<FormResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormResult {
  FormResult({
    this.id,
    this.customer,
    this.item,
    this.estimatedFee,
    this.total,
    this.status,
    this.receiptDate,
    this.estimatedDate,
    this.createdAt,
    this.updatedAt,
    this.parts,
  });

  int id;
  String customer;
  String item;
  int estimatedFee;
  int total;
  int status;
  DateTime receiptDate;
  DateTime estimatedDate;
  DateTime createdAt;
  DateTime updatedAt;
  List<Part> parts;

  factory FormResult.fromJson(Map<String, dynamic> json) => FormResult(
    id: json["id"] == null ? null : json["id"],
    customer: json["customer"] == null ? null : json["customer"],
    item: json["item"] == null ? null : json["item"],
    estimatedFee: json["estimated_fee"] == null ? null : json["estimated_fee"],
    total: json["total"] == null ? null : json["total"],
    status: json["status"] == null ? null : json["status"],
    receiptDate: json["receipt_date"] == null ? null : DateTime.parse(json["receipt_date"]),
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    parts: json["parts"] == null ? null : List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "customer": customer == null ? null : customer,
    "item": item == null ? null : item,
    "estimated_fee": estimatedFee == null ? null : estimatedFee,
    "total": total == null ? null : total,
    "status": status == null ? null : status,
    "receipt_date": receiptDate == null ? null : receiptDate.toIso8601String(),
    "estimated_date": estimatedDate == null ? null : estimatedDate.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "parts": parts == null ? null : List<dynamic>.from(parts.map((x) => x.toJson())),
  };
}

class Part {
  Part({
    this.id,
    this.formId,
    this.name,
    this.qty,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  String name;
  int qty;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    qty: json["qty"] == null ? 0 : json["qty"],
    price: json["price"] == null ? 0 : json["price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "qty": qty == null ? null : qty,
    "price": price == null ? null : price,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
