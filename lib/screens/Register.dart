import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
                  Text('Register', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 22)),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'nama tidak boleh kosong';
                      }
                      return null;
                    },
                    controller: nameController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Nama',
                      prefixIcon: Icon(Icons.person),
                    ),
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
                          icon: isObscured == false ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        )),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    title: 'Register',
                    color: Colors.amber,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        register(nameController.text, usernameController.text, passController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future register(String name, String username, String password) async {
    try {
      final response = await Dio().post(
        "http://10.0.2.2:8000/api/admin/user-register",
        options: Options(headers: {"Accept": "application/json"}),
        queryParameters: {
          'name': name,
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
        Flushbar(
          message: "Registrasi berhasil",
          duration: Duration(seconds: 3),
        )..show(context).then((value) => Get.to(Login()));
      }
    } on DioError catch (e) {
      print(e.response.data['message']);
      if (e.response.data['message'].toString().contains('SQLSTATE')) {
        Flushbar(
          title: "Gagal register",
          message: "Username $username sudah terdaftar",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      } else {
        Flushbar(
          title: "Gagal register",
          message: e.response.statusMessage,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      }
    }
  }
}
