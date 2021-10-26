import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service/componen/success-page.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/models/part-model.dart';
import 'package:service/screens/error-page.dart';
import 'package:service/services/api.dart';

class DataDetailController extends GetxController {
  final api = APIService();
  var order = OrderDetail().obs;
  var orderItem = [OrderItem()].obs;
  var item = [ItemModel()].obs;
  var listCount = [].obs;
  var isLoading = true.obs;
  var orderId = 0.obs;
  var qty = 0.obs;
  var itemSearch = ''.obs;
  var itemId = 0.obs;

  late Future<List<ItemModel>> itemFuture;

  late TextEditingController problemController;
  late TextEditingController repairFeeController;
  var priceController = TextEditingController().obs;
  late TextEditingController itemController;
  NumberFormat currency = NumberFormat.decimalPattern();

  late Worker worker;

  Future<void> refresh() async {
    final result = await api.getOrderDetail(orderId.value);
    order.value = result;
  }

  void fetchPart() {
    api.getItem().then((value) {
      item.value = value;
    }, onError: (e) {});
  }

  void updateStatus(int id, int status) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()));
      api.updateOrder(id, status: status);
      Get.off(() => SuccessPage(message: 'Berhasil simpan detail service'));
    } on Exception catch (e) {
      Get.off(() => ErrorPage(message: 'Gagal simpan detail service, coba beberapa saat lagi'));
    }
  }

  void updateDate(int id, DateTime estimatedDate) async {
    await api.updateOrder(id, estimatedDate: estimatedDate);
    Get.rawSnackbar(message: 'Berhasil update order');
  }

  void addOrderItem(int orderId, int itemId) async {
    api.createOrderItem(orderId, itemId).then((value) {
      fetchData(orderId);
    }, onError: (e) {
      print(e.toString());
    });
  }

  void updateProblem(int id, String problem) async {
    await api.updateOrder(id, problem: problem).catchError((e) => print(e));
    Get.rawSnackbar(message: 'Berhasil update masalah barang');
  }

  void updateRepairFee(int id, repairFee) async {
    await api.updateOrder(id, repairFee: repairFee).catchError((e) => print(e));
    Get.rawSnackbar(message: 'Berhasil update biaya service');
  }

  void updateOrderItemQty() {
    orderItem.forEach((element) async {
      api.updateOrderItem(element.id!, qty: element.qty).catchError((e) => print(e));
    });
  }

  Future<void> updateOrderPrice(int id, int price) async {
    await api.updateOrderItem(id, price: price).catchError((e) => print(e));
    Get.rawSnackbar(message: 'Berhasil update harga part');
  }

  void deleteOrderItem(int orderId, int itemId) {
    api.deleteOrderItem(itemId).then((value) {
      fetchData(orderId);
    }, onError: (e) {
      print(e);
    });
  }

  void increment(id, initialQty) {
    if (id != orderId.value) {
      qty(0);
    } else if (qty.value == initialQty + 1) {
      qty.value++;
      print(qty.value);
    }
  }

  void fetchData(int id) {
    api.getOrderDetail(id).then((value) {
      order.value = value;
    });
  }

  void getItem(String itemName) async {
    final response = await APIService().getItem(search: itemName);
    item.assignAll(response);
  }

  @override
  void onInit() {
    super.onInit();
    debounce(itemSearch, (value) => getItem(value.toString()));
    debounce(qty, (_) => updateOrderItemQty());
    itemFuture = APIService().getItem();
    problemController = TextEditingController();
    itemController = TextEditingController();
    repairFeeController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    problemController.dispose();
    itemController.dispose();
    repairFeeController.dispose();
  }
}
