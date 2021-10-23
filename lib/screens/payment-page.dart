import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/controllers/payment-controller.dart';
import 'package:service/models/order-model.dart';
import 'package:service/services/api.dart';

import '../responsive.dart';
import '../style.dart';
import 'Technician/technician-page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final controller = Get.put(PaymentController());
  List<String> tabList = ['Tunai', 'Non Tunai'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !Responsive.isMobile(context)
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Pembayaran',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: controller.tabController,
            indicatorColor: kPrimary,
            labelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: tabList.map((e) => Tab(child: Text(e))).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder<List<Order>>(
                  future: APIService().getOrder(status: 0),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (Responsive.isMobile(context)) return PaymentList(order: snapshot.data);
                      return Container(
                        height: Get.height * .70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: PaymentList(
                          order: snapshot.data,
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                FutureBuilder(
                  future: APIService().getOrder(status: 0),
                  builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (Responsive.isMobile(context)) return PaymentList(order: snapshot.data!);
                      return Container(
                        height: Get.height * .70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: PaymentList(
                          order: snapshot.data!,
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentList extends StatefulWidget {
  const PaymentList({Key? key, required this.order}) : super(key: key);
  final List<Order> order;
  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);
  late ScrollController scrollController;
  int currentPage = 1;
  bool hasMore = false;
  List<Order> data = [];
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final value = await APIService().getOrder(page: currentPage + 1, status: 0);
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
    data = widget.order;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(horizontal: defaultPadding / 2) : EdgeInsets.zero,
      controller: scrollController,
      shrinkWrap: true,
      itemCount: hasMore ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == data.length) {
          return _buildProgressIndicator();
        }
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () => Get.toNamed('/service/detail', arguments: data[index].id),
                  contentPadding: EdgeInsets.zero,
                  title: Text(data[index].item!.itemName, style: content),
                  subtitle: Row(
                    children: [
                      Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(DateFormat('d MMMM y', 'id').format(data[index].createdAt!), style: header),
                    ],
                  ),
                  trailing: Text(data[index].customer!.name!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildProgressIndicator() {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new CircularProgressIndicator(),
    ),
  );
}
