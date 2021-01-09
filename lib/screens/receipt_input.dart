import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/componen/custom_text_field.dart';
import 'package:service/sercvices/api.dart';

class ReceiptInput extends StatefulWidget {
  @override
  _ReceiptInputState createState() => _ReceiptInputState();
}

class _ReceiptInputState extends State<ReceiptInput> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.amber);
    isButtonVisible = true;
    card2Visible = false;
    tfEnable1 = true;
    API.getForm();
  }

  var customerController = TextEditingController();
  var itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Receipt Input',
          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            height: mediaQ.height * .25,
            width: mediaQ.width,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  customCard1(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isButtonVisible;
  bool card2Visible;
  bool tfEnable1;

  Card customCard1() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('TANGGAL TERIMA',
                    style:
                        GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                Spacer(),
                Text('JAM',
                    style:
                        GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
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
            Text(
              'CUSTOMER',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            CustomTextField(
              enable: tfEnable1,
              controller: customerController,
              readOnly: false,
              icon: Icon(Icons.person),
            ),
            SizedBox(height: 20),
            Text(
              'BARANG',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            CustomTextField(
              enable: tfEnable1,
              controller: itemController,
              readOnly: false,
              icon: Icon(Icons.inventory),
            ),
            Visibility(
              visible: isButtonVisible,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CustomButton(
                    onTap: () {},
                    color: customerController.text.isNotEmpty && itemController.text.isNotEmpty
                        ? Colors.amber
                        : Colors.grey,
                    title: 'Simpan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card customCard2(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(15),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESTIMASI BIAYA',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            CustomTextField(
              readOnly: false,
              keyboardType: TextInputType.number,
              icon: Icon(Icons.monetization_on),
            ),
            SizedBox(height: 20),
            Text(
              'ESTIMASI TANGGAL SELESAI',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            CustomTextField(
              onTap: () => _selectDate(context),
              readOnly: true,
              icon: Icon(Icons.date_range),
            ),
            SizedBox(height: 20),
            CustomButton(
              onTap: () {
                if (customerController.text.isNotEmpty && itemController.text.isNotEmpty) {
                  setState(() {
                    isButtonVisible = false;
                    card2Visible = true;
                    tfEnable1 = false;
                  });
                }
              },
              color: customerController.text.isNotEmpty && itemController.text.isNotEmpty
                  ? Colors.amber
                  : Colors.grey,
              title: 'Simpan',
            ),
          ],
        ),
      ),
    );
  }
}
