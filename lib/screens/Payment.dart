import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final items = List.generate(10, (index) => '$index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Pembayaran', style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => SizedBox(
                  child: Card(
                    child: Container(
                      width: Get.width,
                      child: ListTile(
                        title: Text('${items[index]}'),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
