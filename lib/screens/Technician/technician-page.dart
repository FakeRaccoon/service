import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Technician/technician-detail-page.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';

class TechnicianPage extends StatefulWidget {
  @override
  _TechnicianPageState createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> with TickerProviderStateMixin {
  late TabController tabController;
  var tabList = ['Proses Pengecekan', 'Siap Dikerjakan', 'Dalam Pengerjaan', 'Selesai Service'];
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
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
              title:
                  Text('Teknisi', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
      body: Responsive(
        mobile: technicianPageContent(),
        tablet: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: technicianPageContent(),
        ),
        web: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: technicianPageContent(),
        ),
      ),
    );
  }

  Widget technicianPageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          isScrollable: true,
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
                future: APIService().getOrder(fromStatus: 0, toStatus: 0),
                builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return TechnicianList(order: snapshot.data!);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 3, toStatus: 3),
                builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return TechnicianList(order: snapshot.data!);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 4, toStatus: 4),
                builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return TechnicianList(order: snapshot.data!);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 5, toStatus: 5),
                builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    return TechnicianList(order: snapshot.data!);
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

class TechnicianList extends StatefulWidget {
  const TechnicianList({Key? key, required this.order}) : super(key: key);
  final List<Order> order;
  @override
  _TechnicianListState createState() => _TechnicianListState();
}

class _TechnicianListState extends State<TechnicianList> {
  late List<Order> data;

  int currentPage = 1;
  bool hasMore = false;

  late ScrollController scrollController;

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    data = widget.order;
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final value = await APIService().getOrder(page: currentPage + 1, fromStatus: 0, toStatus: 0);
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
    return ListView.builder(
      padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(horizontal: defaultPadding / 2) : EdgeInsets.zero,
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
          case 1:
            status = 'Menunggu Harga';
            break;
          case 2:
            status = 'Dalam Pengerjaan';
            break;
        }
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
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
                  onTap: () => Get.toNamed('/service/detail', arguments: data[index].id),
                  contentPadding: EdgeInsets.zero,
                  title: data[index].manualItem == null
                      ? Text(data[index].item!.itemName!, style: content)
                      : Text(data[index].manualItem!, style: content),
                  subtitle: Row(
                    children: [
                      Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(DateFormat('d MMMM y', 'id').format(data[index].createdAt!), style: header),
                    ],
                  ),
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
