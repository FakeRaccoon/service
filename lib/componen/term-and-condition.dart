import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/style.dart';

class TermAndCondition extends StatelessWidget {
  const TermAndCondition({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Get.back(),
                ),
                title: Text('Syarat dan Ketentuan', style: AppStyle.headerStyle),
              ),
              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Terima Syarat dan Ketentuan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
