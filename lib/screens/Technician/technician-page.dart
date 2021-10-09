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

class _TechnicianPageState extends State<TechnicianPage> {
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
      body: FutureBuilder<List<Order>>(
        future: APIService().getOrder(status: 0),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (Responsive.isMobile(context)) {
              return TechnicianList(order: snapshot.data);
            }
            return Container(
              height: Get.height * .70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: TechnicianList(
                order: snapshot.data,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
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
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                      Text(DateFormat('d MMMM y').format(data[index].createdAt!), style: header),
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
