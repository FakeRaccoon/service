import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:service/componen/parts-bottom-sheet.dart';
import 'package:service/controllers/data-detail-controller.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/services/api.dart';

import '../../style.dart';

class ResponsiveSparePartDetailPage extends StatelessWidget {
  final id = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        body: SparePartDetailPage(id: id),
      ),
      tablet: Scaffold(
        body: SparePartDetailPage(id: id),
      ),
      web: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: 1200,
            child: SparePartDetailPage(id: id),
          ),
        ),
      ),
    );
  }
}

class SparePartDetailPage extends StatefulWidget {
  const SparePartDetailPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _SparePartDetailPageState createState() => _SparePartDetailPageState();
}

class _SparePartDetailPageState extends State<SparePartDetailPage> {
  final controller = Get.put(DataDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Part Detail',
          style: GoogleFonts.sourceSansPro(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<OrderDetail>(
        future: APIService().getOrderDetail(widget.id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            controller.order.value = snapshot.data!;
            return Obx(() {
              final order = controller.order.value;
              return SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.item!.itemName!, style: AppStyle.headerStyle),
                        SizedBox(height: 20),
                        Text('Sparepart yang dibutuhkan', style: AppStyle.headerStyle),
                        if (order.orderItems!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: order.orderItems!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Get.dialog(
                                    buildDialog(order, index),
                                  );
                                },
                                contentPadding: EdgeInsets.only(right: 15),
                                title: Text(order.orderItems![index].item!.itemName!),
                                subtitle: Text('Harga belum ditentukan'),
                                trailing: Text('x${order.orderItems![index].qty!}'),
                              );
                            },
                          ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(80, 80, 80, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Simpan',
                                    style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(80, 80, 80, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Proses Service',
                                    style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildDialog(OrderDetail order, int index) {
    return Dialog(
      child: Container(
        width: Get.width / 3,
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
              title: Text('Tentukan Harga Part', style: AppStyle.headerStyle),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text('${order.orderItems![index].item!.itemName}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: controller.priceController.value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'isi harga barang';
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ThousandsFormatter(),
                ],
                decoration: InputDecoration(labelText: 'Harga barang', border: InputBorder.none, prefixText: 'Rp'),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.problemController.clear();
                  },
                  child: Text('Simpan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottomSheet(BuildContext context, OrderItem item) {
  //   return showMaterialModalBottomSheet(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  //     context: context,
  //     builder: (BuildContext context) => Padding(
  //       padding: MediaQuery.of(context).viewInsets,
  //       child: Form(
  //         key: key,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               contentPadding: EdgeInsets.zero,
  //               leading: IconButton(
  //                 icon: Icon(Icons.clear),
  //                 onPressed: null,
  //               ),
  //               title: Text('Harga Barang', style: AppStyle.headerStyle),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 10),
  //               child: TextFormField(
  //                 keyboardType: TextInputType.number,
  //                 controller: priceController,
  //                 validator: (value) {
  //                   if (value!.isEmpty) {
  //                     return 'isi harga barang';
  //                   }
  //                   return null;
  //                 },
  //                 decoration: InputDecoration(labelText: 'Harga barang', border: InputBorder.none),
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             Padding(
  //               padding: const EdgeInsets.all(10),
  //               child: SizedBox(
  //                 width: Get.width,
  //                 child: ElevatedButton(
  //                   onPressed: priceController.text.isNotEmpty
  //                       ? () {
  //                           // find.updateOrderItem(item.id, item.qty, priceController.text);
  //                           priceController.clear();
  //                           Get.back();
  //                         }
  //                       : null,
  //                   child: Text('Simpan'),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
