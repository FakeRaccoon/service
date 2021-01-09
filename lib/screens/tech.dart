import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/componen/custom_text_field.dart';
import 'package:service/models/form.dart';
import 'package:service/models/item_model.dart';
import 'package:service/models/parts_model.dart';
import 'package:service/sercvices/api.dart';

class Tech extends StatefulWidget {
  @override
  _TechState createState() => _TechState();
}

class _TechState extends State<Tech> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    fetchForm();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  fetchForm() {
    setState(() {
      loading = true;
    });
    API.getForm().then((value) => form = value).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
    API.getItems().then((value) => item = value);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TextEditingController> feeController = new List();
  List<TextEditingController> dateController = new List();
  List<FormResult> form = List();
  List<ItemResult> item = List();
  // List<PartsResult> part = List();
  List dummy = [];
  List tempo = [];
  bool loading;

  var currency = NumberFormat.decimalPattern();

  DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Part dan Biaya',
          style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchForm();
            },
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            height: mediaQ.height * .25,
            width: mediaQ.width,
          ),
          loading == true
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: ListView.builder(
                    itemCount: form.length,
                    itemBuilder: (BuildContext context, int index) {
                      feeController.add(new TextEditingController());
                      dateController.add(new TextEditingController());
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                Text(
                                  'Please add more info',
                                  style: GoogleFonts.sourceSansPro(fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'CARI SPAREPART',
                                      style: GoogleFonts.sourceSansPro(
                                          fontWeight: FontWeight.bold, color: Colors.grey),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        iconSize: 20,
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          showMaterialModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            )),
                                            context: context,
                                            builder: (context) => buildContainer(context, index),
                                          );
                                          dummy.clear();
                                        }),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: form[index].parts.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.only(right: 20),
                                      title: Row(
                                        children: [
                                          Text(form[index].parts[idx].name),
                                          Spacer(),
                                          Text('x' + form[index].parts[idx].qty.toString()),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'ESTIMASI BIAYA PERBAIKAN',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                CustomTextField(
                                  controller: feeController[index],
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  icon: Icon(Icons.monetization_on),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'ESTIMASI TANGGAL SELESAI',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                CustomTextField(
                                  controller: dateController[index],
                                  onTap: () async {
                                    final DateTime picked = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2015, 8),
                                        lastDate: DateTime(2101));
                                    if (picked != null && picked != selectedDate)
                                      setState(() {
                                        selectedDate = picked;
                                        dateController[index].text =
                                            DateFormat('d MMMM y').format(selectedDate).toString();
                                        selectedDate = DateTime.now();
                                      });
                                  },
                                  readOnly: true,
                                  icon: Icon(Icons.date_range),
                                ),
                                SizedBox(height: 20),
                                CustomButton(
                                  onTap: () {
                                    print(form[index].id);
                                  },
                                  title: 'Simpan',
                                  color: Colors.amber,
                                ),
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

  Container buildContainer(BuildContext context, int index) {
    return Container(
      height: MediaQuery.of(context).size.height * .50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih sparepart',
              style: GoogleFonts.sourceSansPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      if (form[index].parts.map((e) => e.name).toList().contains(item[i].item)) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(item[i].item + ' Sudah ada dalam list'),
                          ),
                        );
                      }
                      if (dummy.contains(item[i].item)) {
                      } else {
                        dummy.remove(item[i].item);
                        dummy.add(item[i].item);
                        dummy = dummy.toSet().toList();
                        dummy.forEach((element) => print(element));
                        print(dummy);
                      }
                    },
                    title: Text(item[i].item),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              onTap: () {
                API.partsCreate(form[index].id, 'Rem', 1);
                Navigator.pop(context);
              },
              color: Colors.amber,
              title: 'Simpan',
            )
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchForm();
  }

  fetchForm() {
    API.getForm().then((value) => form = value).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  List<FormResult> form = List();
  List dummy = [];
  bool loading;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LinearProgressIndicator(backgroundColor: Colors.amber)
        : Container(
            height: MediaQuery.of(context).size.height * .40,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih sparepart',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: form.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(form[index].item),
                        value: form[index].selected,
                        onChanged: (bool value) {
                          setState(() {
                            form[index].selected = value;
                            if (value == true) {
                              dummy.add(form[index].item);
                            } else {
                              dummy.remove(form[index].item);
                            }
                          });
                        },
                      );
                    },
                  ),
                  Spacer(),
                  CustomButton(
                    onTap: () {
                      print(dummy);
                    },
                    color: Colors.amber,
                    title: 'Simpan',
                  )
                ],
              ),
            ),
          );
  }
}
