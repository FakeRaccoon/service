import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/services/api.dart';

import '../style.dart';

class ServiceProposal extends StatefulWidget {
  const ServiceProposal({Key? key}) : super(key: key);

  @override
  _ServiceProposalState createState() => _ServiceProposalState();
}

class _ServiceProposalState extends State<ServiceProposal> {
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
      body: FutureBuilder<List<Order>>(
        future: APIService().getOrder(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('Tidak ada data'),
              );
            }
            if (Responsive.isMobile(context)) {
              return OrderList(orders: snapshot.data!);
            }
            return Container(
              height: Get.height * .70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: OrderList(orders: snapshot.data!),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  final List<Order> orders;
  const OrderList({Key? key, required this.orders}) : super(key: key);

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

  Future<void> refresh() async {
    final order = await APIService().getOrder();
    setState(() {
      data = order;
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.orders;
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final value = await APIService().getOrder(page: currentPage + 1);
        if (value.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            currentPage++;
            hasMore = true;
            data.addAll(value);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(horizontal: defaultPadding / 2) : EdgeInsets.zero,
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        itemCount: hasMore ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == data.length) {
            return _buildProgressIndicator();
          }
          final convert = data[index].status;
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          status,
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await storage.write('orderId', data[index].id);
                      Get.toNamed('/proposal/detail');
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(data[index].item!.itemName, style: content),
                    subtitle: Row(
                      children: [
                        Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                        SizedBox(width: 5),
                        Text(DateFormat('d MMMM y', 'id').format(data[index].createdAt!), style: header),
                      ],
                    ),
                    trailing: Text(data[index].customer!.name!, style: header),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  NumberFormat currency = NumberFormat.decimalPattern();

  TextStyle titleStyle = GoogleFonts.sourceSansPro(color: Colors.grey[800]);

  final id = GetStorage().read('orderId');

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
      bottomNavigationBar: Responsive.isMobile(context)
          ? BottomAppBar(
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
            )
          : null,
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
            return SingleChildScrollView(
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
                            trailing:
                                Text('${DateFormat('d MMMM y, hh:mm', 'id').format(snapshot.data!.createdAt!)} WIB'),
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
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Dp (75% dari Total)',
                                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                            trailing: Text('Rp${currency.format(total * 75 / 100)}',
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
                              Text('Terima '),
                              InkWell(
                                onTap: () {},
                                child: Text('Syarat dan Ketentuan', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
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
