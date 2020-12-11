import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('username');
    if (username != null) {
      setState(() {
        name = username;
      });
      print(name);
    }
  }

  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Akun Saya',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(name ?? 'null'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
