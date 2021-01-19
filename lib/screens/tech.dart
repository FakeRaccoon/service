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
import 'package:service/models/item_model.dart';
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
    fetch();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  List<TextEditingController> feeController = [];
  List<TextEditingController> dateController = [];
  List<TextEditingController> countValue = [];
  List<FormResult> form = [];
  List<ItemResult> item = [];
  // List<PartsResult> part = List();
  List dummy = [];
  List newItems = [];
  List tempo = [];
  List itemIndex = [];
  List sumList = [];
  bool loading;
  bool sparepartLoading;

  var currency = NumberFormat.decimalPattern();

  DateTime selectedDate = DateTime.now();

  fetch() {
    API.getForm(1).then((value) => form = value).whenComplete(() {
      setState(() {});
    });
    API.getItems().then((value) => item = value);
  }

  Future getRefresh(index) async {
    API.getForm(1).then((value) => form = value).whenComplete(() {
      setState(() {});
      sumList.clear();
      form[index].parts.toList().forEach((element) {
        int sum = element.qty * element.price;
        sumList.add(sum);
        print(element.price);
        print(element.qty);
      });
      int sumSum = sumList.fold(0, (p, e) => p + e);
      print(sumSum);
      if (sumSum != 0) {
        API.formTotal(form[index].id, sumSum.toString()).whenComplete(() => fetch());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Teknisi',
          style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetch();
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
          SafeArea(
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
                          ListTile(
                            title: Text(form[index].item,
                                style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              Spacer(),
                              IconButton(
                                  iconSize: 20,
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    newItems.clear();
                                    dummy.clear();
                                    item.toList().forEach((element) {
                                      setState(() {
                                        element.selected = false;
                                      });
                                    });
                                    form[index].parts.toList().forEach((element) {
                                      setState(() {
                                        var idx = item.toList().indexWhere((val) => val.item == element.name);
                                        item[idx].selected = true;
                                        dummy.add(item[idx].item);
                                        print(dummy);
                                      });
                                    });
                                    showMaterialModalBottomSheet(
                                      isDismissible: false,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      )),
                                      context: context,
                                      builder: (context) => buildContainer(context, index),
                                    );
                                  }),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: form[index].parts.length,
                            itemBuilder: (BuildContext context, int idx) {
                              countValue.add(new TextEditingController());
                              return buildListTile(index, idx);
                            },
                          ),
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
                              if (feeController[index].text.isNotEmpty && dateController[index].text.isNotEmpty) {
                                var q = int.parse(feeController[index].text.replaceAll(",", ""));
                                // print(form[index].parts[idx].qty);
                                API.formUpdate(form[index].id, selectedDate, q).whenComplete(() {
                                  Navigator.pop(context);
                                  fetch();
                                });
                              }
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

  ListTile buildListTile(int index, int idx) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: 20),
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              API.partsDelete(form[index].parts[idx].id);
              fetch();
            },
          ),
          Text(form[index].parts[idx].name),
          Spacer(),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (form[index].parts[idx].qty != 1) {
                setState(() {
                  form[index].parts[idx].qty -= 1;
                });
              }
              API.partsQty(form[index].parts[idx].id, form[index].parts[idx].qty).whenComplete(() => getRefresh(index));
            },
          ),
          Text(form[index].parts[idx].qty.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                form[index].parts[idx].qty += 1;
              });
              API.partsQty(form[index].parts[idx].id, form[index].parts[idx].qty).whenComplete(() => getRefresh(index));
            },
          ),
        ],
      ),
    );
  }

  buildContainer(BuildContext context, int index) {
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
                        newItems.clear();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, i) {
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item[i].item),
                        onChanged: (bool value) {
                          if (value == false && dummy.contains(item[i].item)) {
                            newItems.remove(item[i].item);
                          } else if (dummy.contains(item[i].item) && value == true) {
                            newItems.remove(item[i].item);
                          } else {
                            newItems.add(item[i].item);
                          }
                          setModalState(() {
                            item[i].selected = value;
                          });
                        },
                        value: item[i].selected,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                CustomButton(
                  onTap: () {
                    // print(dummy);
                    itemIndex.clear();
                    form[index].parts.toList().forEach((element) {
                      setState(() {
                        var idx = item.toList().indexWhere((val) => val.item == element.name);
                      });
                    });
                    print(newItems.toSet().toList());
                    if (newItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Tidak ada item yg dipilih'),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      newItems.forEach((element) => API.partsCreate(form[index].id, element, 1));
                    }
                    Navigator.pop(context);
                    fetch();
                  },
                  color: Colors.amber,
                  title: 'Simpan',
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
