// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.username,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  int? id;
  String? username;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  Role? role;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "role": role == null ? null : role!.toJson(),
  };
}

class Role {
  Role({
    required this.id,
    required this.name,
    required this.level,
  });

  int id;
  String name;
  int level;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    level: json["level"] == null ? null : json["level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "level": level,
  };
}
