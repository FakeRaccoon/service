import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/componen/custom_text_field.dart';
import 'package:service/models/form.dart';
import 'package:service/sercvices/api.dart';

class SparePart extends StatefulWidget {
  @override
  _SparePartState createState() => _SparePartState();
}

class _SparePartState extends State<SparePart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    fetch();
  }

  fetch() {
    API.getForm(2).then((value) => form = value).whenComplete(() {
      setState(() {});
    });
  }

  Future getRefresh(index) async {
    API.getForm(2).then((value) => form = value).whenComplete(() {
      setState(() {});
      sumList.clear();
      form[index].parts.toList().forEach((element) {
        int sum = element.qty * element.price;
        sumList.add(sum);
      });
      int sumSum = sumList.fold(0, (p, e) => p + e);
      print(sumSum);
      if (sumSum != 0) {
        API.formTotal(form[index].id, sumSum.toString()).whenComplete(() => fetch());
      }
    });
  }

  var feeController = TextEditingController();
  List<FormResult> form = List();
  bool loading;
  List sumList = [];

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    var currency = NumberFormat.decimalPattern();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Part dan Biaya',
          style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            height: mediaQ.height * .25,
            width: mediaQ.width,
          ),
          SafeArea(
            child: ListView.builder(
              itemCount: form.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ExpandablePanel(
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            form[index].item,
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: form[index].parts.length,
                            itemBuilder: (BuildContext context, int idx) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    )),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return buildContainer(mediaQ, index, idx);
                                    }),
                                title: Row(
                                  children: [
                                    Text(form[index].parts[idx].name),
                                    Spacer(),
                                    Text(form[index].parts[idx].price != 0
                                        ? 'Rp ' + currency.format(form[index].parts[idx].price).toString()
                                        : ''),
                                    SizedBox(width: 20),
                                    Text('x' + form[index].parts[idx].qty.toString()),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                form[index].total == 0 ? 0 : 'Rp ' + currency.format(form[index].total ?? 0).toString(),
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          CustomButton(
                            title: 'Simpan',
                            color: Colors.amber,
                            onTap: () {},
                          )
                          // ListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   title: Row(
                          //     children: [
                          //       Text(
                          //         'Total',
                          //         style: GoogleFonts.sourceSansPro(
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Text('Rp ' + form[index].total.toString()),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  buildContainer(Size mediaQ, int index, int idx) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Input harga',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Text(
                'Input harga untuk sparepart ${form[index].parts[idx].name}.',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: feeController,
                inputFormat: [CurrencyTextInputFormatter(decimalDigits: 0)],
                prefix: Text('Rp '),
                readOnly: false,
                keyboardType: TextInputType.number,
                icon: Icon(Icons.monetization_on),
              ),
              SizedBox(height: 10),
              CustomButton(
                title: 'Simpan',
                color: Colors.amber,
                onTap: () {
                  if (feeController.text.isNotEmpty) {
                    var q = int.parse(feeController.text.replaceAll(',', ''));
                    API.partsUpdate(form[index].parts[idx].id, q).whenComplete(() {
                      getRefresh(index);
                    });

                    Navigator.pop(context);
                    feeController.clear();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
