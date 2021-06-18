import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/models/form.dart';
import 'package:service/sercvices/api.dart';

class ServiceProposal extends StatefulWidget {
  const ServiceProposal({Key key}) : super(key: key);

  @override
  _ServiceProposalState createState() => _ServiceProposalState();
}

class _ServiceProposalState extends State<ServiceProposal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Service Proposal', style: GoogleFonts.sourceSansPro(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class ServiceProposalDetail extends StatefulWidget {
  @override
  _ServiceProposalDetailState createState() => _ServiceProposalDetailState();
}

class _ServiceProposalDetailState extends State<ServiceProposalDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // formFuture = API.getForm(3);
  }

  Future formFuture;

  Future onRefresh() async {
    formFuture = API.getForm(3);
    setState(() {});
  }

  bool isChecked = false;
  List<FormResult> form = [];

  int part1 = 1;

  bool checkValue = false;

  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat.decimalPattern();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Proposal Service',
            style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(227, 227, 225, 1),
            height: Get.height * .25,
            width: Get.width,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
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
                              Text('JAM',
                                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                          Text('TANGGAL SELESAI',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text(
                            DateFormat('d MMMM y').format(DateTime.now()).toString(),
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('MASALAH',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BIAYA PART',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Part 1'),
                                subtitle: Text('Rp 150.000'),
                                trailing: Text('1x'),
                              ),
                              Divider(thickness: 1),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Part 2'),
                                subtitle: Text('Rp 200.000'),
                                trailing: Text('2x'),
                              ),
                            ],
                          ),
                          // SizedBox(height: 10),
                          // Text('BIAYA',
                          //     style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Biaya Perbaikan'),
                            trailing: Text('Rp 2.000.000'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Total', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                            trailing:
                                Text('Rp 2.350.000', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  splashRadius: 1,
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
                          SizedBox(height: 20),
                          SizedBox(
                            width: Get.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(80, 80, 80, 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {},
                              child: Text('Simpan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
