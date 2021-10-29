import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/controllers/login-controller.dart';
import 'package:service/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Login', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 22)),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    onChanged: (value) {
                      controller.username(value);
                    },
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'username tidak boleh kosong';
                      }
                      if (value.length < 3) {
                        return 'username harus minimal 3 karakter';
                      }
                      if (controller.isExist.isFalse) {
                        return 'username ini tidak terdaftar';
                      }
                      return null;
                    },
                    controller: controller.userController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: controller.isExist.value ? Icon(Icons.check) : SizedBox(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    onChanged: (value) {
                      controller.password(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password tidak boleh kosong';
                      }
                      if (value.length < 3) {
                        return 'password harus minimal 3 karakter';
                      }
                    },
                    obscureText: controller.obscured.value,
                    controller: controller.passController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => controller.obscured.toggle(),
                        icon: controller.obscured.isTrue ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding + 10),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.clickCount++;
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
