import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta/meta.dart';
import 'package:service/models/user-model.dart';
import 'package:service/services/api.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  var viewIndex = 0.obs;

  late User user;

  List<String> tabs = [
    'Pengajuan Service',
    'Proposal Service',
    'Serah Terima',
    // 'Part',
  ];

  Future<void> logout() async {
    Get.dialog(Center(child: CircularProgressIndicator(color: Colors.white)));
    APIService().logout().then((value) {
      Get.offAllNamed('/');
    }, onError: (e) {
      Get.back();
      Get.rawSnackbar(
        messageText: Text(
          'Gagal logout, silahkan coba beberapa saat lagi',
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
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
