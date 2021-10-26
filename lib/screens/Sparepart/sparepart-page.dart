import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/controllers/data-controller.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';

class SparePartPage extends StatefulWidget {
  @override
  _SparePartPageState createState() => _SparePartPageState();
}

class _SparePartPageState extends State<SparePartPage> with TickerProviderStateMixin {
  final controller = Get.put(DataController());
  NumberFormat currency = NumberFormat.decimalPattern();
  late TabController tabController;
  var tabList = ['Tetapkan Harga', 'Selesai'];
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
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
                'Sparepart',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
      body: Responsive(
        mobile: sparepartPageContent(),
        tablet: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: sparepartPageContent(),
        ),
        web: Container(
          height: Get.height * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: sparepartPageContent(),
        ),
      ),
    );
  }

  Widget sparepartPageContent() {
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
                future: APIService().getOrder(fromStatus: 1, toStatus: 1),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    controller.dataList.value = snapshot.data!;
                    return SparePartList();
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder(
                future: APIService().getOrder(fromStatus: 2, toStatus: 2),
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data'));
                    controller.dataList.value = snapshot.data!;
                    return SparePartList();
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

class SparePartList extends StatefulWidget {
  @override
  _SparePartListState createState() => _SparePartListState();
}

class _SparePartListState extends State<SparePartList> {
  final controller = Get.find<DataController>();

  int currentPage = 1;

  late ScrollController scrollController;

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        controller.fetchMoreData();
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
      itemCount: controller.hasMore.value ? controller.dataList.length + 1 : controller.dataList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == controller.dataList.length) {
          return _buildProgressIndicator();
        }
        final convert = controller.dataList[index].status;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
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
                  onTap: () => Get.toNamed('/part/detail', arguments: controller.dataList[index].id),
                  contentPadding: EdgeInsets.zero,
                  title: controller.dataList[index].manualItem == null
                      ? Text(controller.dataList[index].item!.itemName!, style: content)
                      : Text(controller.dataList[index].manualItem!, style: content),
                  subtitle: Row(
                    children: [
                      Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(DateFormat('d MMMM y', 'id').format(controller.dataList[index].createdAt!), style: header),
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}
