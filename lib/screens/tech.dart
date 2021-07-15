import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/componen/custom_text_field.dart';
import 'package:service/models/order-model.dart';
import 'package:service/screens/ServiceProposal.dart';
import 'package:service/sercvices/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tech extends StatefulWidget {
  @override
  _TechState createState() => _TechState();
}

class _TechState extends State<Tech> {
  NumberFormat currency = NumberFormat.decimalPattern();

  SharedPreferences sharedPreferences;

  TextEditingController problemController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Teknisi', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: APIService().getOrder(1, null),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return TechnicianList(order: snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TechnicianList extends StatefulWidget {
  final OrderModel order;
  const TechnicianList({Key key, this.order}) : super(key: key);

  @override
  _TechnicianListState createState() => _TechnicianListState();
}

class _TechnicianListState extends State<TechnicianList> {
  List<Datum> data;

  int currentPage = 1;
  bool hasMore = false;

  ScrollController scrollController = ScrollController();

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  Future refresh() async {
    APIService().getOrder(1, null).then((value) {
      OrderModel value;
      setState(() {
        data = value.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.order.data;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        APIService().getOrder(currentPage + 1, null).then((value) {
          if (value.data.isEmpty) {
            setState(() {
              hasMore = false;
            });
          } else {
            setState(() {
              currentPage++;
              hasMore = true;
              data.addAll(value.data);
            });
          }
        });
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
        controller: scrollController,
        shrinkWrap: true,
        itemCount: hasMore ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == data.length) {
            return _buildProgressIndicator();
          }
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(data[index].item ?? '-', style: content),
                    subtitle: Row(
                      children: [
                        Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                        SizedBox(width: 5),
                        Text(DateFormat('d MMMM y').format(data[index].createdAt) ?? '-', style: header),
                      ],
                    ),
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
