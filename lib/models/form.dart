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
    this.total,
    this.status,
    this.selected,
    this.estimatedDate,
    this.createdAt,
    this.updatedAt,
    this.parts,
  });

  int id;
  String customer;
  String item;
  int total;
  int status;
  bool selected;
  DateTime estimatedDate;
  DateTime createdAt;
  DateTime updatedAt;
  List<Part> parts;

  factory FormResult.fromJson(Map<String, dynamic> json) => FormResult(
    id: json["id"],
    customer: json["customer"],
    item: json["item"],
    total: json["total"] == null ? null : json["total"],
    status: json["status"],
    selected: json["selected"],
    estimatedDate: json["estimated_date"] == null ? null : DateTime.parse(json["estimated_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer": customer,
    "item": item,
    "total": total == null ? null : total,
    "status": status,
    "selected": selected,
    "estimated_date": estimatedDate == null ? null : estimatedDate.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
  };
}

class Part {
  Part({
    this.id,
    this.formId,
    this.name,
    this.qty,
    this.price,
    this.selected,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  String name;
  int qty;
  dynamic price;
  bool selected;
  DateTime createdAt;
  DateTime updatedAt;

  factory Part.fromJson(Map<String, dynamic> json) => Part(
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
