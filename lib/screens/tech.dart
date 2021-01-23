import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/componen/custom_text_field.dart';
import 'package:service/models/form.dart';
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
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    formFuture = API.getForm(1);
    form2Future = API.getForm(2);
    partsFuture = API.getItems();
  }

  List<TextEditingController> feeController = [];
  List<TextEditingController> dateController = [];
  List<TextEditingController> countValue = [];

  Future formFuture;
  Future form2Future;
  Future partsFuture;

  var currency = NumberFormat.decimalPattern();

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> selectedParts = [];

  Future getRefresh(index) async {}

  Future getSelectedParts() async {
    var decoded = jsonEncode(selectedParts);
    final parts = selectedPartsFromJson(decoded);
    print(decoded);
    return parts;
  }

  Future fetchSelectedParts() async {
    getSelectedParts().then((value) => fetchedParts = value).whenComplete(() {
      setState(() {});
    });
  }

  List<SelectedParts> fetchedParts = [];

  List<String> tabBar = ["Baru", "Confirmed"];

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Teknisi',
            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            )
          ],
          elevation: 0,
          backgroundColor: Colors.amber,
          bottom: TabBar(
            labelPadding: EdgeInsets.all(10),
            automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey[800],
            controller: tabController,
            tabs: [
              Text(
                'Pending',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Confirmed',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'On Process',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                color: Colors.amber,
                height: mediaQ.height * .25,
                width: mediaQ.width,
              ),
            ),
            TabBarView(
              children: [
                pendingUI(),
                partsUI(),
                Text('3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingUI() {
    return FutureBuilder(
      future: formFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return cardFormList(snapshot);
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        );
      },
    );
  }

  Widget partsUI() {
    return FutureBuilder(
      future: form2Future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return confirmedFormList(snapshot);
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        );
      },
    );
  }

  Widget cardFormList(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
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
                  ListTile(
                    title: Text(snapshot.data[index].item,
                        style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              expanded: Form(
                child: Column(
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
                          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        Spacer(),
                        IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                              context: context,
                              builder: (context) => sparePartsSelect(context, index),
                            );
                          },
                        ),
                      ],
                    ),
                    sparePartsDisplay(),
                    SizedBox(height: 20),
                    Text(
                      'ESTIMASI BIAYA PERBAIKAN',
                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    CustomTextField(
                      onChange: (String value) {
                        print(value);
                      },
                      inputFormat: [CurrencyTextInputFormatter(decimalDigits: 0)],
                      prefix: Text('Rp '),
                      controller: feeController[index],
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
                            dateController[index].text = DateFormat('d MMMM y').format(selectedDate).toString();
                          });
                      },
                      readOnly: true,
                      icon: Icon(Icons.date_range),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      onTap: () {
                        var q = int.parse(feeController[index].text.replaceAll(",", ""));
                        API
                            .formUpdate(snapshot.data[index].id, selectedDate, q)
                            .then((value) => fetchedParts.toList().forEach((element) {
                                  API.partsCreate(snapshot.data[index].id, element.name, element.qty);
                                }))
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                        fetchedParts.toList().forEach((element) {
                          print('${element.name} == ${element.qty}');
                        });
                      },
                      title: 'Simpan',
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget confirmedFormList(AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ExpandablePanel(
              header: Text(
                snapshot.data[index].item,
                style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              expanded: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data[index].parts.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Text(snapshot.data[index].parts[idx].name),
                            Spacer(),
                            Text(snapshot.data[index].parts[idx].price != 0
                                ? 'Rp ' + currency.format(snapshot.data[index].parts[idx].price).toString()
                                : ''),
                            SizedBox(width: 20),
                            Text('x' + snapshot.data[index].parts[idx].qty.toString()),
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
                        snapshot.data[index].total == 0
                            ? 0
                            : 'Rp ' + currency.format(snapshot.data[index].total ?? 0).toString(),
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    title: 'Proses',
                    color: Colors.amber,
                    onTap: () {},
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget sparePartsDisplay() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: fetchedParts.length,
      itemBuilder: (_, i) {
        countValue.add(new TextEditingController());
        return ListTile(
          contentPadding: EdgeInsets.only(right: 20),
          title: Row(
            children: [
              Text(fetchedParts[i].name),
              Spacer(),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (fetchedParts[i].qty != 1) {
                    setState(() {
                      fetchedParts[i].qty -= 1;
                    });
                  }
                  print(fetchedParts[i].name);
                },
              ),
              Text(fetchedParts[i].qty.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    fetchedParts[i].qty += 1;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget sparePartsSelect(BuildContext context, int index) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * .50,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Pilih sparepart',
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
                FutureBuilder(
                  future: partsFuture,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(snapshot.data[i].item),
                              onChanged: (bool value) {
                                setModalState(() {
                                  snapshot.data[i].selected = value;
                                });
                                if (value == true) {
                                  selectedParts.add({"name": snapshot.data[i].item, "qty": 1});
                                }
                                if (value == false) {
                                  selectedParts.removeWhere((element) => element.containsValue(snapshot.data[i].item));
                                }
                              },
                              value: snapshot.data[i].selected,
                            );
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  color: Colors.amber,
                  title: 'Proses',
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

List<SelectedParts> selectedPartsFromJson(String str) =>
    List<SelectedParts>.from(json.decode(str).map((x) => SelectedParts.fromJson(x)));

String selectedPartsToJson(List<SelectedParts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectedParts {
  SelectedParts({
    this.name,
    this.qty,
  });

  String name;
  int qty;

  factory SelectedParts.fromJson(Map<String, dynamic> json) => SelectedParts(
        name: json["name"] == null ? null : json["name"],
        qty: json["qty"] == null ? null : json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "qty": qty == null ? null : qty,
      };
}
