import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/services/api.dart';

import '../style.dart';

class FinalTransaction extends StatefulWidget {
  const FinalTransaction({Key? key}) : super(key: key);

  @override
  _FinalTransactionState createState() => _FinalTransactionState();
}

class _FinalTransactionState extends State<FinalTransaction> with TickerProviderStateMixin {
  late TabController tabController;
  var tabList = ['Serah Terima', 'Selesai'];
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !Responsive.isMobile(context)
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Serah Terima',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
      body: Column(
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
                  future: APIService().getOrder(fromStatus: 5, toStatus: 5),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                      return OrderList(status: 0, orders: snapshot.data!);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                FutureBuilder(
                  future: APIService().getOrder(fromStatus: 6, toStatus: 6),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                      return OrderList(status: 0, orders: snapshot.data!);
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
