import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/componen/loading-page.dart';
import 'package:service/componen/success-page.dart';
import 'package:service/models/customer-model.dart';
import 'package:service/models/item-model.dart';
import 'package:service/screens/error-page.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/services/api.dart';

class ReceiptInputController extends GetxController {
  late Timer timer;
  late TextEditingController customerController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  late TextEditingController itemController;
  late TextEditingController manualItemController;
  late TextEditingController itemConditionController;
  late TextEditingController problemController;
  var dateTime = DateTime.now().obs;
  var itemSearch = ''.obs;
  var customerSearch = ''.obs;

  late Future<List<ItemModel>> itemFuture;
  late Future<List<CustomerModel>> customerFuture;

  var itemList = [ItemModel()].obs;
  var customerList = [CustomerModel()].obs;
  var itemId = 0.obs;

  var isNewItem = false.obs;

  var isNewCustomer = true.obs;

  void getItem(String item) async {
    final response = await APIService().getItem(search: item);
    itemList.assignAll(response);
  }

  void getCustomer(String customer) async {
    final response = await APIService().getCustomer(search: customer);
    customerList.assignAll(response);
  }

  Future<void> createOrder() async {
    try {
      Get.to(() => LoadingPage(message: 'Transaksi dalam proses.'));
      await APIService().createOrder(
        customerController.text,
        addressController.text,
        int.parse(phoneNumberController.text),
        itemConditionController.text,
        itemId: itemId.value == 0 ? null : itemId.value,
        manualItem: manualItemController.text.isEmpty ? null : manualItemController.text,
      );
      customerController.clear();
      phoneNumberController.clear();
      addressController.clear();
      itemController.clear();
      Get.off(() => SuccessPage(message: 'Berhasil buat transaksi baru.'));
    } on Exception catch (e) {
      Get.off(() => ErrorPage(message: 'Gagal memproses transaksi, coba beberapa saat lagi'));
    }
  }

  @override
  void onInit() {
    super.onInit();
    debounce(itemSearch, (value) => getItem(value.toString()));
    debounce(customerSearch, (value) => getCustomer(value.toString()));
    itemFuture = APIService().getItem();
    customerFuture = APIService().getCustomer();
    customerController = TextEditingController();
    manualItemController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
    itemController = TextEditingController();
    problemController = TextEditingController();
    itemConditionController = TextEditingController();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      dateTime.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    super.onClose();
    customerController.dispose();
    manualItemController.dispose();
    itemConditionController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    itemController.dispose();
    problemController.dispose();
    timer.cancel();
  }
}
