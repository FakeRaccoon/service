// To parse this JSON data, do
//
//     final partModel = partModelFromJson(jsonString);

import 'dart:convert';

PartModel partModelFromJson(String str) => PartModel.fromJson(json.decode(str));

String partModelToJson(PartModel data) => json.encode(data.toJson());

class PartModel {
  PartModel({
    this.status,
    this.data,
    this.meta,
  });

  int? status;
  List<PartData>? data;
  Meta? meta;

  factory PartModel.fromJson(Map<String, dynamic> json) => PartModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : List<PartData>.from(json["data"].map((x) => PartData.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta == null ? null : meta!.toJson(),
      };
}

class PartData {
  PartData({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PartData.fromJson(Map<String, dynamic> json) => PartData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class Meta {
  Meta({
    this.total,
    this.filteredData,
    this.perPage,
    this.currentPage,
  });

  int? total;
  int? filteredData;
  int? perPage;
  int? currentPage;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"] == null ? null : json["total"],
        filteredData: json["filtered_data"] == null ? null : json["filtered_data"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        currentPage: json["current_page"] == null ? null : json["current_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "filtered_data": filteredData == null ? null : filteredData,
        "per_page": perPage == null ? null : perPage,
        "current_page": currentPage == null ? null : currentPage,
      };
}
