import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/body.dart';
import 'package:service/componen/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
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

  var usernameController = TextEditingController();
  var passController = TextEditingController();

  String externalIds;

  @override
  Widget build(BuildContext context) {
    // String md5Convert() {
    //   return md5.convert(utf8.encode(passController.text)).toString();
    // }

    return Scaffold(
      body: SafeArea(
        child: Form(
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
                    Text(
                      'Login',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
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
                            icon: isObscured == false
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          )),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      title: 'Login',
                      color: Colors.amber,
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          print(usernameController.text);
                          print(passController.text);
                          // loginTest(usernameController.text, md5Convert());
                          loginTest(usernameController.text, passController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTest() async {
    var url = "http://10.0.2.2:8000/api/user";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  loginTest(String username, String password) async {
    // String baseUrl = 'http://192.168.0.7:4948/api/login/signin';
    String baseUrl = "http://10.0.2.2:8000/api/login";
    var response = await http.post(baseUrl, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'];
      print(data['token']);
      print(data['name']);
      print(data['role']);
      setState(() {
        _name = data['name'];
        _token = data['token'];
        _role = data['role'];
        setUserInfoPreference()
            .then((value) => Center(child: CircularProgressIndicator()))
            .whenComplete(() {
          setUserInfoPreference();
          Get.offAll(Body());
        });
      });
    } else {
      print('error');
    }
  }

  String _name;
  String _token;
  String _role;

  Future<void> setUserInfoPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('name', _name);
    prefs.setString('token', _token);
    prefs.setString('role', _role);
  }
}
