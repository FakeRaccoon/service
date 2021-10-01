import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/controllers/data-detail-controller.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/part-model.dart';
import 'package:service/style.dart';

class PartBottomSheet extends StatefulWidget {
  const PartBottomSheet({Key? key}) : super(key: key);

  @override
  _PartBottomSheetState createState() => _PartBottomSheetState();
}

class _PartBottomSheetState extends State<PartBottomSheet> {
  final find = Get.find<DataDetailController>();

  @override
  Widget build(BuildContext context) {
    return GetX<DataDetailController>(
      builder: (controller) {
        if (controller.item.isNotEmpty) {
          List<ItemModel> item = controller.item;
          return Container(
            height: Get.height * 0.70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title: Text('Part', style: AppStyle.headerStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        hintText: 'Cari part',
                        hintStyle: GoogleFonts.sourceSansPro(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: item.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        // if (controller.data.orderItems!
                        //     .map((e) => e.orderItemPart!.name)
                        //     .contains(part[index].name)) {
                        //   find.updateOrderItem(part[index].id, 2, null);
                        // } else {
                        //   find.addOrderItem(part[index].id, 1, null);
                        // }
                        // Get.back();
                      },
                      contentPadding: EdgeInsets.zero,
                      title: Text(item[index].itemName!, style: AppStyle.bodyStyle),
                    ),
                    separatorBuilder: (BuildContext context, int index) => Divider(
                      thickness: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}