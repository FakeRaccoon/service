import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.web,
  }) : super(key: key);

  final Widget mobile;
  final Widget tablet;
  final Widget web;

  static bool isMobile(BuildContext context) => Get.width < 650;
  static bool isWeb(BuildContext context) => Get.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 650) {
        return mobile;
      } else if (constraints.maxWidth < 1100 && constraints.maxWidth >= 650) {
        return tablet;
      } else if (constraints.maxWidth >= 1100) {
        return web;
      }
      throw Exception('UI Error');
    });
  }
}
