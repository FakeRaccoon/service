import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/models/form.dart';
import 'package:service/sercvices/api.dart';

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    fetch();
  }

  Future fetch() async {
    API.getForm(3).then((value) => form = value).whenComplete(() {
      setState(() {});
    });
  }

  bool isChecked = false;
  List<FormResult> form = List();

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    var currency = NumberFormat.decimalPattern();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Tanda terima',
          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            height: mediaQ.height * .25,
            width: mediaQ.width,
          ),
          buildSafeArea(mediaQ, currency),
        ],
      ),
    );
  }

  SafeArea buildSafeArea(Size mediaQ, NumberFormat currency) {
    return SafeArea(
      child: ListView.builder(
        itemCount: form.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ExpandablePanel(
                  header: ListTile(
                    title: Text(form[index].customer,
                        style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(form[index].item),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w800, fontSize: 32),
                      ),
                      Divider(
                        endIndent: 20,
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          Text('TANGGAL',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          Spacer(),
                          Text('JAM',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('d MMMM y').format(form[index].receiptDate).toString(),
                            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Spacer(),
                          Text(DateFormat.jm().format(form[index].receiptDate).toString(),
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('CUSTOMER',
                          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(
                        form[index].customer,
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text('LIST PART DAN BIAYA',
                          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: form[index].parts.length,
                        itemBuilder: (BuildContext context, int idx) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Text(form[index].parts[idx].name),
                                Spacer(),
                                Text('Rp ${currency.format(form[index].parts[idx].price).toString()}'),
                                SizedBox(width: 20),
                                Text('x${form[index].parts[idx].qty.toString()}'),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text('BIAYA PERBAIKAN',
                          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(
                        'Rp ${currency.format(form[index].estimatedFee)}',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text('TOTAL BIAYA',
                          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(
                        'Rp ${currency.format(form[index].total)}',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.amber,
                            value: isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                isChecked = value;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () => showMaterialModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => ClipRRect(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                child: StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setModalState) {
                                    return Container(
                                      width: mediaQ.width,
                                      height: mediaQ.height / 2,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Text('User agreement',
                                                style: GoogleFonts.sourceSansPro(
                                                    fontWeight: FontWeight.bold, fontSize: 16)),
                                            SizedBox(height: 10),
                                            Text(
                                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce et lacinia tortor. Nunc pellentesque ut metus sit amet faucibus. Vivamus venenatis erat non dolor porttitor gravida. Phasellus vestibulum, sapien ut imperdiet molestie, purus sapien cursus metus, vitae ultrices urna tortor a massa. Sed a ultrices augue. Nulla facilisi. Donec lacinia blandit metus sed sodales. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam congue est sit amet efficitur tincidunt. Suspendisse orci ligula, volutpat at sem dapibus, tempor congue dui.',
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.sourceSansPro(fontSize: 16),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  activeColor: Colors.amber,
                                                  value: isChecked,
                                                  onChanged: (bool value) {
                                                    setModalState(() {
                                                      isChecked = value;
                                                    });
                                                    setState(() {
                                                      if (isChecked == true) {
                                                        Navigator.pop(context);
                                                      }
                                                      isChecked = value;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Agree',
                                                  style: GoogleFonts.sourceSansPro(color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            child: Text('Term and conditions'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        onTap: () {
                          isChecked == false ? print('disabled') : print('ok');
                        },
                        title: 'Confirm',
                        color: isChecked == false ? Colors.grey : Colors.amber,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
