import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/body.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/models/LoginInfo.dart';
import 'package:service/screens/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscured = true;
  }

  bool isObscured = true;
  void _toggle() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String externalIds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Login', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 22)),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'username tidak boleh kosong';
                      }
                      return null;
                    },
                    controller: usernameController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'password tidak boleh kosong';
                      }
                      return null;
                    },
                    obscureText: isObscured,
                    controller: passController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: isObscured == false ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        )),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    title: 'Login',
                    color: Colors.amber,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        login(usernameController.text, passController.text)
                            .then((value) => loginInfo = value)
                            .whenComplete(() {
                          print(loginInfo.role.roleName);
                          print(loginInfo.pages.map((e) => e.pageName).toList());
                          print(loginInfo.pages.map((e) => e.pageGroup).toList());
                          setUserInfoPreference(
                            loginInfo.name,
                            loginInfo.token,
                            loginInfo.role.roleName,
                            loginInfo.pages.map((e) => e.pageName).toList(),
                            loginInfo.pages.map((e) => e.pageGroup).toList(),
                          ).then((value) => Center(child: CircularProgressIndicator())).whenComplete(() {
                            Get.offAll(Body());
                          });
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () => Get.to(Register()),
                    child: Text('Register', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LoginInfo loginInfo;

  List<Map<String, dynamic>> selectedPages = [];

  Future login(String username, String password) async {
    try {
      final response = await Dio().post(
        "http://10.0.2.2:8000/api/login",
        options: Options(contentType: "application/json"),
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final login = loginInfoFromJson(jsonEncode(response.data['data']));
        return login;
        // selectedPages.clear();
        // // pages.forEach((element) {
        // //   selectedPages.add(element);
        // //   print(selectedPages);
        // // });
      }
    } on DioError catch (e) {
      Flushbar(
        title: "Gagal login",
        message: e.message,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }

  Future setUserInfoPreference(name, token, role, pageList, pageCategoryList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('token', token);
    prefs.setString('role', role);
    prefs.setStringList('pageList', pageList);
    prefs.setStringList('pageCategoryList', pageCategoryList);
  }
}
