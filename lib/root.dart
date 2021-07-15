import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/body.dart';
import 'package:service/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Get.offAll(() => Login());
    } else {
      Get.offAll(() => Home());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
