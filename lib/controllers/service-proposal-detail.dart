import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/componen/success-page.dart';
import 'package:service/screens/error-page.dart';
import 'package:service/services/api.dart';

class ServiceProposalController extends GetxController {
  void updateStatus(int id, int status, { double? dp }) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()));
      await APIService().updateOrder(id, status: status);
      await APIService().updatePayment(id, dp: dp);
      Get.off(() => SuccessPage(message: 'Berhasil simpan detail service'));
    } on Exception catch (e) {
      Get.off(() => ErrorPage(message: 'Gagal simpan detail service, coba beberapa saat lagi'));
    }
  }
}
