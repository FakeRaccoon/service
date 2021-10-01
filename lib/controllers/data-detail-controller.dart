import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/models/part-model.dart';
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

  void updateOrderItem(id, itemQty) {
    api.updateOrderItem(id, qty: itemQty).then((value) {
      fetchData(orderId.value);
    }, onError: (e) {});
  }

  void deleteOrderItem(id) {
    api.deleteOrderItem(id).then((value) {
      fetchData(orderId.value);
    }, onError: (e) {});
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
    itemFuture = APIService().getItem();
    problemController = TextEditingController();
    itemController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    problemController.dispose();
  }
}