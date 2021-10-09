import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/screens/home.dart';
import 'package:service/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root.dart';

class LoginController extends GetxController {
  final api = APIService();
  final box = GetStorage();

  late TextEditingController userController;
  late TextEditingController passController;

  var clickCount = 0.obs;
  var username = ''.obs;
  var password = ''.obs;
  var isExist = false.obs;

  var obscured = true.obs;

  late Worker worker;

  void fetchUser() {
    api.getUser(username.value).then((value) {
      isExist.value = true;
    }, onError: (e) {
      isExist.value = false;
    });
  }

  void login() async {
    api.login(userController.text, passController.text).then((value) async {
      await box.write('token', value['token']);
      await box.write('refreshToken', value['refreshToken']);
      Get.offAllNamed('/');
    }, onError: (e) {
      Get.rawSnackbar(
        messageText: Text(
          'Login gagal, cek username atau password',
          style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.red,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    userController = TextEditingController();
    passController = TextEditingController();
    worker = debounce(clickCount, (_) {
      login();
    });
    worker = debounce(username, (value) {
      fetchUser();
    }, time: 1.seconds);
  }

  @override
  void onClose() {
    super.onClose();
    userController.dispose();
    passController.dispose();
    worker.dispose();
  }
}
