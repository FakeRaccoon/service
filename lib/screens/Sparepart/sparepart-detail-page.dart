import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/parts-bottom-sheet.dart';
import 'package:service/controllers/data-detail-controller.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/services/api.dart';

import '../../style.dart';

class SparePartDetailPage extends StatefulWidget {
  const SparePartDetailPage({Key? key}) : super(key: key);

  @override
  _SparePartDetailPageState createState() => _SparePartDetailPageState();
}

class _SparePartDetailPageState extends State<SparePartDetailPage> {
  final id = Get.arguments;

  DataDetailController put = Get.put(DataDetailController());
  DataDetailController find = Get.find();

  TextEditingController priceController = TextEditingController();

  final api = APIService();

  final key = GlobalKey<FormState>();

  late Future orderFuture;

  refresh() async {
    orderFuture = api.getOrderDetail(id);
    // orderFuture = api.getOrderDetail(data.id);
    setState(() {});
  }

  @override
  void initState() {
    find.fetchData(id);
    find.orderId(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Detail Barang',
            style: GoogleFonts.sourceSansPro(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder<OrderDetail>(
          future: APIService().getOrderDetail(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final order = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order!.item!.itemName!, style: AppStyle.headerStyle),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Sparepart yang dibutuhkan', style: AppStyle.headerStyle),
                              Spacer(),
                              IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.add, size: 20),
                                onPressed: null,
                              ),
                            ],
                          ),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: order.orderItems!.length,
                            itemBuilder: (BuildContext context, int index) {
                              OrderItem item = find.orderItem[index];
                              return ListTile(
                                onTap: () => bottomSheet(context, item),
                                contentPadding: EdgeInsets.only(right: 20),
                                title: Text('${item.item!.itemName}', style: AppStyle.bodyStyle),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(item.price == null ? '' : 'Rp '),
                                    Text('${item.price == null ? '' : find.currency.format(item.price)}',
                                        style: AppStyle.bodyStyle),
                                    SizedBox(width: 10),
                                    Text('x${item.qty}', style: AppStyle.bodyStyle),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Scaffold(
        body: FutureBuilder<OrderDetail>(
          future: APIService().getOrderDetail(id),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              OrderDetail order = snapshot.data;
              return Column(
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
                                onPressed: order.problem == null
                                    ? () {
                                        // bottomSheet(context, order);
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
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      locale: LocaleType.id,
                                      minTime: DateTime.now(),
                                      maxTime: DateTime(2023), onConfirm: (DateTime time) {
                                    // print(time);
                                    // APIService()
                                    //     .updateOrder(
                                    //   data.id,
                                    //   order.data![0].problem,
                                    //   time.toString(),
                                    // )
                                    //     .then((value) {
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
                                    // });
                                  });
                                },
                              ),
                            ],
                          ),
                          if (order.estimatedDate != null)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                DateFormat('d MMMM y').format(order.estimatedDate!),
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
                                  showMaterialModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                    context: context,
                                    builder: (context) => PartBottomSheet(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    }
  }

  bottomSheet(BuildContext context, OrderItem item) {
    return showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: null,
                ),
                title: Text('Harga Barang', style: AppStyle.headerStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isi harga barang';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Harga barang', border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: priceController.text.isNotEmpty
                        ? () {
                            // find.updateOrderItem(item.id, item.qty, priceController.text);
                            priceController.clear();
                            Get.back();
                          }
                        : null,
                    child: Text('Simpan'),
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
