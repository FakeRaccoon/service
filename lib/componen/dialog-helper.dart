import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHelper {
  static void showErrorDialog({String title = 'Error', String description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Get.textTheme.headline4),
            Text(description, style: Get.textTheme.bodyText1),
          ],
        ),
      ),
    );
  }

  static void showSnackBar({String title = 'Error', String description = 'Something went wrong'}) {
    Get.snackbar(title, description);
  }
}
