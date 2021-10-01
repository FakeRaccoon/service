import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  var viewIndex = 0.obs;

  List<String> tabs = [
    'Pengajuan Service',
    'Proposal Service',
    'Service',
    'Part',
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
