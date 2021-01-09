import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('name');
    final role = sharedPreferences.getString('role');
    if (username != null) {
      setState(() {
        name = username;
        userRole = role;
      });
      print(name);
    } else {
      Get.offAll(Login());
    }
  }

  logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();
    getUserInfo();
  }

  String name;
  String userRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Akun Saya',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.network(
                      'https://www.btklsby.go.id/images/placeholder/basic.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'null',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userRole ?? 'null',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
