import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/parts-bottom-sheet.dart';
import 'package:service/controllers/data-detail-controller.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/services/api.dart';

import '../../style.dart';

class ResponsiveTechnicianDetailPage extends StatefulWidget {
  const ResponsiveTechnicianDetailPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _ResponsiveTechnicianDetailPageState createState() => _ResponsiveTechnicianDetailPageState();
}

class _ResponsiveTechnicianDetailPageState extends State<ResponsiveTechnicianDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: TechnicianDetailPage(id: widget.id),
      tablet: TechnicianDetailPage(id: widget.id),
      web: Center(
        child: Container(
          width: 1200,
          child: TechnicianDetailPage(id: widget.id),
        ),
      ),
    );
  }
}

class TechnicianDetailPage extends StatefulWidget {
  const TechnicianDetailPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _TechnicianDetailPageState createState() => _TechnicianDetailPageState();
}

class _TechnicianDetailPageState extends State<TechnicianDetailPage> {
  final controller = Get.put(DataDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<OrderDetail>(
        future: controller.api.getOrderDetail(widget.id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            controller.order.value = snapshot.data!;
            return Obx(() {
              final order = controller.order.value;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: Row(
                          children: [
                            Text('Service Detail', style: AppStyle.headerStyle.copyWith(fontSize: 18)),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.item!.itemName!, style: AppStyle.headerStyle),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Masalah barang', style: AppStyle.headerStyle),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.add, size: 20),
                                  onPressed: order.problem == null && kIsWeb
                                      ? () {
                                          Get.dialog(inputProblemDialog());
                                        }
                                      : null,
                                ),
                              ],
                            ),
                            if (order.problem != null)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(order.problem!, style: AppStyle.bodyStyle),
                                trailing: IconButton(
                                  color: Colors.black,
                                  disabledColor: Colors.grey,
                                  icon: Icon(Icons.edit, size: 20),
                                  onPressed: () {
                                    // bottomSheet(context, order);
                                  },
                                ),
                              ),
                            Divider(thickness: 1),
                            Row(
                              children: [
                                Text('Estimasi selesai', style: AppStyle.headerStyle),
                                Spacer(),
                                IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.date_range_rounded, size: 20),
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      locale: const Locale('id', 'ID'),
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2025),
                                    );
                                    controller.order.update((val) {
                                      val!.estimatedDate = date;
                                    });
                                    // DatePicker.showDatePicker(context,
                                    //     locale: LocaleType.id,
                                    //     minTime: DateTime.now(),
                                    //     maxTime: DateTime(2023), onConfirm: (DateTime time) {
                                    //   print(time);
                                    //   APIService()
                                    //       .updateOrder(
                                    //     data.id,
                                    //     order.data![0].problem,
                                    //     time.toString(),
                                    //   )
                                    //       .then((value) {
                                    //     refresh();
                                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    //       content: Text('Berhasil Update Data'),
                                    //       behavior: SnackBarBehavior.floating,
                                    //     ));
                                    //   }, onError: (e) {
                                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    //       backgroundColor: Colors.red,
                                    //       content: Text(e),
                                    //       behavior: SnackBarBehavior.floating,
                                    //     ));
                                    //   });
                                    // });
                                  },
                                ),
                              ],
                            ),
                            if (order.estimatedDate != null)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  DateFormat('d MMMM y').format(controller.order.value.estimatedDate!),
                                  style: AppStyle.bodyStyle,
                                ),
                              ),
                            Divider(thickness: 1),
                            Row(
                              children: [
                                Text('Sparepart yang dibutuhkan', style: AppStyle.headerStyle),
                                Spacer(),
                                IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    Get.dialog(itemSearchDialog());
                                    // showMaterialModalBottomSheet(
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.vertical(
                                    //       top: Radius.circular(20),
                                    //     ),
                                    //   ),
                                    //   context: context,
                                    //   builder: (context) => PartBottomSheet(),
                                    // );
                                  },
                                ),
                              ],
                            ),
                            if (order.orderItems!.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: order.orderItems!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(order.orderItems![index].item!.itemName!),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (order.orderItems![index].qty! != 1) {
                                              controller.order.update((val) {
                                                val!.orderItems![index].qty = (val.orderItems![index].qty! - 1);
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text('${order.orderItems![index].qty!}'),
                                        IconButton(
                                          onPressed: () {
                                            controller.order.update((val) {
                                              val!.orderItems![index].qty = (val.orderItems![index].qty! + 1);
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Dialog itemSearchDialog() {
    return Dialog(
      child: Container(
        height: Get.height,
        width: Get.width / 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cari Part',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (String value) {
                  controller.itemSearch.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'Cari part',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<ItemModel>>(
                  future: controller.itemFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      controller.item.value = snapshot.data!;
                      if (snapshot.data!.isEmpty) return Text('Terjadi Kesalahan');
                      return Obx(
                        () {
                          if (controller.item.isEmpty) return Center(child: Text('Barang tidak ditemukan'));
                          return ListView.separated(
                            itemCount: controller.item.length,
                            itemBuilder: (context, index) {
                              final item = controller.item[index];
                              return ListTile(
                                onTap: () {
                                  controller.addOrderItem(widget.id, item.id!);
                                  Get.back();
                                },
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.itemName!),
                                subtitle: Text(item.itemAlias!),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputProblemDialog() => Dialog(
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
                title: Text('Masalah Barang', style: AppStyle.headerStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: controller.problemController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isi masalah barang';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Masalah barang', border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.order.update((val) {
                        val!.problem = controller.problemController.text;
                      });
                      Get.back();
                      // APIService()
                      //     .updateOrder(data.id, problemController.text, order.data?[0].estimatedDate)
                      //     .then((value) {
                      //   Get.back();
                      //   refresh();
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text('Berhasil Update Data'),
                      //     behavior: SnackBarBehavior.floating,
                      //   ));
                      // }, onError: (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     backgroundColor: Colors.red,
                      //     content: Text(e),
                      //     behavior: SnackBarBehavior.floating,
                      //   ));
                      //   Get.back();
                      // });
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

// bottomSheet(BuildContext context, order) {
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
//               title: Text('Masalah Barang', style: AppStyle.headerStyle),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: TextFormField(
//                 controller: problemController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'isi masalah barang';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(labelText: 'Masalah barang', border: InputBorder.none),
//               ),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: SizedBox(
//                 width: Get.width,
//                 child: ElevatedButton(
//                   onPressed: problemController.text.isNotEmpty
//                       ? () {
//                           // APIService()
//                           //     .updateOrder(data.id, problemController.text, order.data?[0].estimatedDate)
//                           //     .then((value) {
//                           //   Get.back();
//                           //   refresh();
//                           //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           //     content: Text('Berhasil Update Data'),
//                           //     behavior: SnackBarBehavior.floating,
//                           //   ));
//                           // }, onError: (e) {
//                           //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           //     backgroundColor: Colors.red,
//                           //     content: Text(e),
//                           //     behavior: SnackBarBehavior.floating,
//                           //   ));
//                           //   Get.back();
//                           // });
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
