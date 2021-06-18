// To parse this JSON data, do
//
//     final loginInfo = loginInfoFromJson(jsonString);

import 'dart:convert';

LoginInfo loginInfoFromJson(String str) => LoginInfo.fromJson(json.decode(str));

String loginInfoToJson(LoginInfo data) => json.encode(data.toJson());

class LoginInfo {
  LoginInfo({
    this.token,
    this.name,
    this.role,
    this.pages,
  });

  String token;
  String name;
  Role role;
  List<Page> pages;

  factory LoginInfo.fromJson(Map<String, dynamic> json) => LoginInfo(
    token: json["token"] == null ? null : json["token"],
    name: json["name"] == null ? null : json["name"],
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
    pages: json["pages"] == null ? null : List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
    "name": name == null ? null : name,
    "role": role == null ? null : role.toJson(),
    "pages": pages == null ? null : List<dynamic>.from(pages.map((x) => x.toJson())),
  };
}

class Page {
  Page({
    this.id,
    this.pageName,
    this.pageGroup,
  });

  int id;
  String pageName;
  String pageGroup;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json["id"] == null ? null : json["id"],
    pageName: json["page_name"] == null ? null : json["page_name"],
    pageGroup: json["page_group"] == null ? null : json["page_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "page_name": pageName == null ? null : pageName,
    "page_group": pageGroup == null ? null : pageGroup,
  };
}

class Role {
  Role({
    this.id,
    this.roleName,
  });

  int id;
  String roleName;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"] == null ? null : json["id"],
    roleName: json["role_name"] == null ? null : json["role_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "role_name": roleName == null ? null : roleName,
  };
}
