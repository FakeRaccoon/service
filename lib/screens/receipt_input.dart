import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/sercvices/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptInput extends StatefulWidget {
  @override
  _ReceiptInputState createState() => _ReceiptInputState();
}

class _ReceiptInputState extends State<ReceiptInput> {
  final _key = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Timer timer;

  SharedPreferences sharedPreferences;

  Future formCreate(customer, item) async {
    var url = 'http://10.0.2.2:8000/api/form/create';
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    try {
      final response = await Dio().post(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        queryParameters: {
          "customer": customer,
          "item": item,
          "status": 1,
          "receipt_date": DateTime.now().toString(),
        },
      );
      if (response.statusCode == 200) {
        customerController.clear();
        itemController.clear();
        Flushbar(
          title: "Berhasil",
          message: response.data['message'],
          duration: Duration(seconds: 3),
        )..show(context);
      }
    } on DioError catch (e) {
      Flushbar(
        title: "Gagal",
        message: e.response.data['message'],
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  TextEditingController customerController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  bool checkValue = false;

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            Get.back();
            timer.cancel();
          },
        ),
        backgroundColor: Color.fromRGBO(227, 227, 225, 1),
        elevation: 0,
        title: Center(
          child: Text(
            'Receipt Input',
            style: GoogleFonts.sourceSansPro(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () {}, child: Text('Done')),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(227, 227, 225, 1),
            height: mediaQ.height * .25,
            width: mediaQ.width,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    customCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customCard() {
    return Form(
      key: _key,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('TANGGAL TERIMA',
                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                  Spacer(),
                  Text('JAM', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  Text(
                    DateFormat('d MMMM y').format(DateTime.now()).toString(),
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  Text(DateFormat.jm().format(DateTime.now()).toString(),
                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 20),
              Divider(thickness: 1),
              SizedBox(height: 20),
              Text('Customer Info', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nama customer!';
                  }
                  return null;
                },
                controller: customerController,
                decoration: InputDecoration(labelText: 'Nama customer'),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nomor telfon customer!';
                  }
                  return null;
                },
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Nomor telfon'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text('Item Details', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nama barang!';
                  }
                  return null;
                },
                controller: itemController,
                decoration: InputDecoration(labelText: 'Nama barang'),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      activeColor: Colors.black,
                      value: checkValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkValue = newValue;
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
              SizedBox(height: 10),
              // SizedBox(
              //   width: Get.width,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       primary: Color.fromRGBO(80, 80, 80, 1),
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //     ),
              //     onPressed: () {
              //       if (_key.currentState.validate()) {
              //         formCreate(customerController.text, itemController.text);
              //       }
              //     },
              //     child: Text('Simpan'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
