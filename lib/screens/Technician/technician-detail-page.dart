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
import 'package:service/models/item-model.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/services/api.dart';

import '../../style.dart';

class ResponsiveTechnicianDetailPage extends StatefulWidget {
  @override
  _ResponsiveTechnicianDetailPageState createState() => _ResponsiveTechnicianDetailPageState();
}

class _ResponsiveTechnicianDetailPageState extends State<ResponsiveTechnicianDetailPage> {
  final id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: TechnicianDetailPage(id: id),
      tablet: TechnicianDetailPage(id: id),
      web: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: 1200,
            child: TechnicianDetailPage(id: id),
          ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Service Detail',
          style: GoogleFonts.sourceSansPro(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: kIsWeb
          ? null
          : BottomAppBar(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: FutureBuilder<OrderDetail>(
        future: APIService().getOrderDetail(widget.id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            controller.order.value = snapshot.data!;
            controller.orderItem.value = snapshot.data!.orderItems!;
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
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Masalah barang', style: AppStyle.headerStyle),
                          trailing: order.problem != null
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    if (kIsWeb)
                                      Get.dialog(inputProblemDialog(order));
                                    else
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return problemBottomSheet(order);
                                        },
                                      );
                                  },
                                ),
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
                                if (kIsWeb)
                                  Get.dialog(inputProblemDialog(order));
                                else
                                  showMaterialModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return problemBottomSheet(order);
                                    },
                                  );
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
                                final newDate = DateTime.now();
                                print(date!.add(Duration(hours: newDate.hour, minutes: newDate.minute)));
                                APIService().updateOrder(order.id!,
                                    estimatedDate: date.add(Duration(hours: newDate.hour, minutes: newDate.minute)));
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
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Biaya Perbaikan', style: AppStyle.headerStyle),
                        ),
                        if (order.payment?.repairFee != null)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Rp${NumberFormat.decimalPattern().format(order.payment!.repairFee)}',
                                style: AppStyle.bodyStyle),
                            trailing: IconButton(
                              color: Colors.black,
                              disabledColor: Colors.grey,
                              icon: Icon(Icons.edit, size: 20),
                              onPressed: () {
                                if (kIsWeb)
                                  Get.dialog(repairFeeDialog(order));
                                else
                                  showMaterialModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return repairFeeBottomSheet(order);
                                    },
                                  );
                              },
                            ),
                          ),
                        Divider(thickness: 1),
                        Row(
                          children: [
                            Text('Part yang dibutuhkan', style: AppStyle.headerStyle),
                            Spacer(),
                            IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.add, size: 20),
                              onPressed: () {
                                if (!Responsive.isMobile(context))
                                  Get.dialog(itemSearchDialog());
                                else
                                  showMaterialModalBottomSheet(
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.vertical(
                                    //     top: Radius.circular(20),
                                    //   ),
                                    // ),
                                    context: context,
                                    builder: (context) => itemSearchBottomSheet(),
                                  );
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
                                leading: IconButton(
                                  onPressed: () => controller.deleteOrderItem(order.id!, order.orderItems![index].id!),
                                  icon: Icon(Icons.delete),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (order.orderItems![index].qty! != 1) {
                                          controller.orderId.value = order.orderItems![index].id!;
                                          controller.qty.value++;
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
                                        controller.orderId.value = order.orderItems![index].id!;
                                        controller.qty.value++;
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
                        SizedBox(height: 30),
                        if (!Responsive.isMobile(context))
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
                                    onPressed: () {
                                      Get.back();
                                    },
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

  Widget repairFeeBottomSheet(OrderDetail order) {
    return Padding(
      padding: Get.mediaQuery.viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Get.back();
                  controller.repairFeeController.clear();
                },
              ),
              title: Text('Biaya perbaikan', style: AppStyle.headerStyle),
            ),
            TextFormField(
              controller: controller.repairFeeController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'isi biaya perbaikan';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ThousandsFormatter(),
              ],
              decoration: InputDecoration(labelText: 'Biaya Perbaikan'),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () async {
                  int repairFee = int.parse(controller.repairFeeController.text.replaceAll(',', ''));
                  controller.order.update((val) {
                    val!.payment?.repairFee = repairFee;
                  });
                  controller.updateRepairFee(order.id!, repairFee);
                  controller.repairFeeController.clear();
                  Get.back();
                },
                child: Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget problemBottomSheet(OrderDetail order) {
    return Padding(
      padding: Get.mediaQuery.viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Get.back();
                  controller.problemController.clear();
                },
              ),
              title: Text(
                'Edit Masalah Mesin',
                style: AppStyle.headerStyle,
              ),
            ),
            TextFormField(
              controller: controller.problemController,
              decoration: InputDecoration(labelText: 'Masalh Mesin'),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  controller.order.update((val) {
                    val!.problem = controller.problemController.text;
                  });
                  controller.updateProblem(order.id!, controller.problemController.text);
                  controller.problemController.clear();
                  Get.back();
                },
                child: Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemSearchBottomSheet() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Get.back();
                },
              ),
              title: Text(
                'Cari Part',
                style: AppStyle.headerStyle,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onChanged: (String value) {
                controller.itemSearch.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Cari part',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
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
    );
  }

  Widget itemSearchDialog() {
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

  Widget inputProblemDialog(OrderDetail order) {
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
                    controller.updateProblem(order.id!, controller.problemController.text);
                    Get.back();
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

  Widget repairFeeDialog(OrderDetail order) {
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
              title: Text('Biaya perbaikan', style: AppStyle.headerStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: controller.repairFeeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'isi biaya perbaikan';
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ThousandsFormatter(),
                ],
                decoration: InputDecoration(labelText: 'Biaya Perbaikan', border: InputBorder.none),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () async {
                    int repairFee = int.parse(controller.repairFeeController.text.replaceAll(',', ''));
                    controller.order.update((val) {
                      val!.payment?.repairFee = repairFee;
                    });
                    controller.updateRepairFee(order.id!, repairFee);
                    Get.back();
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
