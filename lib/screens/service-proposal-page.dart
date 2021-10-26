import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service/controllers/data-detail-controller.dart';
import 'package:service/controllers/service-proposal-detail.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/services/api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../style.dart';

class ServiceProposal extends StatefulWidget {
  const ServiceProposal({Key? key}) : super(key: key);

  @override
  _ServiceProposalState createState() => _ServiceProposalState();
}

class _ServiceProposalState extends State<ServiceProposal> with TickerProviderStateMixin {
  final controller = Get.put(ServiceProposalController());
  late TabController tabController;
  var tabList = ['Dalam Proses', 'Siap Diajukan'];
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !Responsive.isMobile(context)
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Service Proposal',
                style: GoogleFonts.sourceSansPro(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      body: Responsive(
        mobile: serviceProposalContent(),
        tablet: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: serviceProposalContent(),
        ),
        web: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: serviceProposalContent(),
        ),
      ),
    );
  }

  Widget serviceProposalContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: kPrimary,
          labelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: tabList.map((e) => Tab(child: Text(e))).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 0, toStatus: 1),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return OrderList(status: 0, orders: snapshot.data!);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 2, toStatus: 2),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return OrderList(status: 1, orders: snapshot.data!);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderList extends StatefulWidget {
  final List<Order> orders;
  final int status;
  const OrderList({Key? key, required this.orders, required this.status}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late List<Order> data;

  final storage = GetStorage();

  int currentPage = 1;
  bool hasMore = false;

  late ScrollController scrollController;

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    data = widget.orders;
    scrollController = ScrollController();
    // scrollController.addListener(() async {
    //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
    //     final value = await APIService().getOrder(page: currentPage + 1);
    //     if (value.isEmpty) {
    //       setState(() {
    //         hasMore = false;
    //       });
    //     } else {
    //       setState(() {
    //         currentPage++;
    //         hasMore = true;
    //         data.addAll(value);
    //       });
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(horizontal: defaultPadding / 2) : EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      itemCount: hasMore ? widget.orders.length + 1 : widget.orders.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.orders.length) {
          return _buildProgressIndicator();
        }
        final convert = widget.orders[index].status;
        late String status;
        switch (convert) {
          case 0:
            status = 'Dalam Proses';
            break;
        }
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Container(
                //     color: Colors.grey[200],
                //     child: Padding(
                //       padding: const EdgeInsets.all(5),
                //       child: Text(
                //         status,
                //         style: GoogleFonts.sourceSansPro(
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () async {
                    await storage.write('orderId', widget.orders[index].id);
                    Get.toNamed('/proposal/detail');
                  },
                  contentPadding: EdgeInsets.zero,
                  title: widget.orders[index].manualItem == null
                      ? Text(widget.orders[index].item!.itemName!, style: content)
                      : Text(widget.orders[index].manualItem!, style: content),
                  subtitle: Row(
                    children: [
                      Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(DateFormat('d MMMM y', 'id').format(widget.orders[index].createdAt!), style: header),
                    ],
                  ),
                  trailing: Text(widget.orders[index].customer!.name!, style: header),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}

class ResponsiveServiceProposalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        backgroundColor: Colors.white,
        body: ServiceProposalDetail(),
      ),
      tablet: Scaffold(
        backgroundColor: Colors.white,
        body: ServiceProposalDetail(),
      ),
      web: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: 1200,
            child: ServiceProposalDetail(),
          ),
        ),
      ),
    );
  }
}

class ServiceProposalDetail extends StatefulWidget {
  @override
  _ServiceProposalDetailState createState() => _ServiceProposalDetailState();
}

class _ServiceProposalDetailState extends State<ServiceProposalDetail> {
  bool isChecked = false;
  bool checkValue = false;

  final controller = Get.put(ServiceProposalController());

  NumberFormat currency = NumberFormat.decimalPattern();

  TextStyle titleStyle = GoogleFonts.sourceSansPro(color: Colors.grey[800]);

  final id = GetStorage().read('orderId');

  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Proposal Service',
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
            int totalItems = 0;
            int total = order!.payment?.repairFee ?? 0;
            if (order.orderItems!.isNotEmpty) {
              for (int i = 0; i < order.orderItems!.length; i++) {
                if (order.orderItems![i].price != null) {
                  totalItems = totalItems + (order.orderItems![i].qty! * order.orderItems![i].price!);
                  total = total + (order.orderItems![i].qty! * order.orderItems![i].price!);
                }
              }
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detail Service',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Tanggal Service',
                                    style: titleStyle,
                                  ),
                                  trailing: Text(
                                      '${DateFormat('d MMMM y, hh:mm', 'id').format(snapshot.data!.createdAt!)} WIB'),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Estimasi Selesai',
                                    style: titleStyle,
                                  ),
                                  trailing: order.estimatedDate == null
                                      ? Text('Belum ada tanggal perkiraan selesai')
                                      : Text('${DateFormat('d MMMM y', 'id').format(order.estimatedDate!)}'),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Customer',
                                    style: titleStyle,
                                  ),
                                  trailing: Text(order.customer!.name!),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Kontak',
                                    style: titleStyle,
                                  ),
                                  trailing: Text(order.customer!.contact.toString().substring(0, 1) == '0'
                                      ? '${order.customer!.contact!}'
                                      : '0${order.customer!.contact!}'),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Masalah Barang',
                                    style: titleStyle,
                                  ),
                                  trailing: Text('${order.problem ?? 'Masalah barang belum ditetapkan'}'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detail Part',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                if (order.orderItems!.isNotEmpty)
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: order.orderItems!.length,
                                    itemBuilder: (context, index) {
                                      final orderItems = order.orderItems![index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(orderItems.item!.itemName!),
                                        subtitle: orderItems.price == null
                                            ? Text('Harga belum ditetapkan')
                                            : Text('Rp ${currency.format(orderItems.price)}'),
                                        trailing: Text('x${orderItems.qty ?? 0}'),
                                      );
                                    },
                                  )
                                else
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Part belum ditentukan'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rincian Biaya',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Total Biaya Part',
                                    style: titleStyle,
                                  ),
                                  trailing: Text('Rp ${currency.format(totalItems)}'),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Biaya Perbaikan',
                                    style: titleStyle,
                                  ),
                                  trailing: Text('Rp ${currency.format(order.payment?.repairFee ?? 0)}'),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Total', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                  trailing: Text('Rp${currency.format(total)}',
                                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                ),
                                if (order.status != 5)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Dp (75% dari Total)',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                    trailing: Text('Rp${currency.format(total * 75 / 100)}',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                  ),
                                if (order.status == 5)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Dp (Lunas)',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                    trailing: Text('Rp${currency.format(total * 75 / 100)}',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                  ),
                                if (order.status == 5)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Sisa Bayar',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                    trailing: Text('Rp${currency.format(total - order.payment!.dp!)}',
                                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                                  ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        splashRadius: 1,
                                        activeColor: Colors.black,
                                        value: checkValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            checkValue = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Telah Disetujui Customer', style: TextStyle(fontWeight: FontWeight.bold)),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child:
                                    //       Text('Syarat dan Ketentuan', style: TextStyle(fontWeight: FontWeight.bold)),
                                    // ),
                                  ],
                                ),
                                if (!Responsive.isMobile(context)) SizedBox(height: 30),
                                if (!Responsive.isMobile(context))
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromRGBO(80, 80, 80, 1),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),
                                        onPressed: () {},
                                        child: Text('Simpan'),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (Responsive.isMobile(context))
                  BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          if (order.status == 2)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: checkValue == true && order.status == 2
                                    ? () {
                                        controller.updateStatus(id, 3, dp: total * 75 / 100);
                                      }
                                    : null,
                                child: Text('Simpan'),
                              ),
                            ),
                          if (order.status == 5)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: checkValue == true && order.status == 5
                                    ? () {
                                        controller.updateStatus(id, 3, dp: total * 75 / 100);
                                      }
                                    : null,
                                child: Text('Simpan'),
                              ),
                            ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                pdf.addPage(
                                  pw.Page(
                                    pageFormat: PdfPageFormat.a4,
                                    build: (pw.Context context) {
                                      return pw.Column(
                                        children: [
                                          pw.Text('Tanda Terima'),
                                          pw.Text(order.customer!.name!),
                                        ],
                                      ); // Center
                                    },
                                  ),
                                );
                                final path = await getApplicationDocumentsDirectory();
                                final file = File('${path.path}/example.pdf');
                                await file.writeAsBytes(await pdf.save());
                                OpenFile.open('${path.path}/example.pdf');
                              },
                              child: Text('Cetak'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
