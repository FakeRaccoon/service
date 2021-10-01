import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/controllers/data-controller.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/Sparepart/sparepart-detail-page.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';

class SparePartPage extends StatefulWidget {
  @override
  _SparePartPageState createState() => _SparePartPageState();
}

class _SparePartPageState extends State<SparePartPage> {
  final controller = Get.put(DataController());
  NumberFormat currency = NumberFormat.decimalPattern();

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
      body: FutureBuilder<List<Order>>(
        future: APIService().getOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            controller.dataList.value = snapshot.data!;
            if(Responsive.isMobile(context)){
              return SparePartList();
            }
            return Container(
              height: Get.height * .70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: SparePartList(),
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
    if (Responsive.isMobile(context)) {
      return ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: controller.hasMore.value ? controller.dataList.length + 1 : controller.dataList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == controller.dataList.length) {
            return _buildProgressIndicator();
          }
          return InkWell(
            onTap: () => Get.to(() => SparePartDetailPage(), arguments: controller.dataList[index].id),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(controller.dataList[index].item!.itemName, style: content),
                      subtitle: Row(
                        children: [
                          Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                          SizedBox(width: 5),
                          Text(DateFormat('d MMMM y').format(controller.dataList[index].createdAt!), style: header),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Obx(
        () => Expanded(
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: controller.hasMore.value ? controller.dataList.length + 1 : controller.dataList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == controller.dataList.length) {
                return _buildProgressIndicator();
              }
              return InkWell(
                // onTap: () => Get.to(() => TechnicianDetailPage(), arguments: controller.dataList[index]),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(controller.dataList[index].item!.itemName, style: content),
                          subtitle: Row(
                            children: [
                              Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                              SizedBox(width: 5),
                              Text(
                                DateFormat('d MMMM y').format(controller.dataList[index].createdAt!),
                                style: header,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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
}
