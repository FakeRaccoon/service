import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/home.dart';
import 'package:service/sercvices/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptInput extends StatefulWidget {
  @override
  _ReceiptInputState createState() => _ReceiptInputState();
}

class _ReceiptInputState extends State<ReceiptInput> {
  final _key = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Timer timer;

  SharedPreferences sharedPreferences;

  TextEditingController customerController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController problemController = TextEditingController();

  bool checkValue = false;

  TextStyle header = GoogleFonts.sourceSansPro();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color.fromRGBO(227, 227, 225, 1),
        elevation: 0,
        title: Center(
          child: Text(
            'Tanda Terima',
            style: GoogleFonts.sourceSansPro(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_key.currentState.validate() && checkValue == true) {
                  APIService().createOrder(itemController.text, problemController.text).then((value) {
                    APIService()
                        .createCustomer(
                      value['data']['id'],
                      customerController.text,
                      addressController.text,
                      phoneNumberController.text,
                    )
                        .then((value) {
                      Get.offAll(() => Home());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Berhasil'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }, onError: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ));
                    });
                  }, onError: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ));
                  });
                } else if (_key.currentState.validate() && checkValue == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Terima Syarat dan Ketentuan'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Lengkapi data'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text('Selesai', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold))),
          SizedBox(width: 5),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(227, 227, 225, 1),
            height: Get.height * .25,
            width: Get.width,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              SizedBox(height: 10),
              Divider(thickness: 1),
              // ListTile(
              //   contentPadding: EdgeInsets.zero,
              //   title: Row(
              //     children: [
              //       Icon(Icons.date_range_rounded, color: Colors.grey[600]),
              //       SizedBox(width: 5),
              //       Text(DateFormat('d MMMM y').format(DateTime.now()) ?? '-', style: header),
              //     ],
              //   ),
              // ),
              SizedBox(height: 10),
              Text('Detail', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nama customer!';
                  }
                  return null;
                },
                controller: customerController,
                decoration: InputDecoration(labelText: 'Nama Customer'),
              ),
              // SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nomor telfon customer!';
                  }
                  return null;
                },
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Nomor Telfon'),
                keyboardType: TextInputType.number,
              ),
              // SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi alamat customer!';
                  }
                  return null;
                },
                controller: addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Isi nama barang!';
                  }
                  return null;
                },
                controller: itemController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
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
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //     ),
              //     onPressed: () {
              //       if (_key.currentState.validate()) {}
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
