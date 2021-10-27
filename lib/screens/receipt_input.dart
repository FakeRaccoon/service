import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:service/componen/term-and-condition.dart';
import 'package:service/controllers/receipt-input-controller.dart';
import 'package:service/models/customer-model.dart';
import 'package:service/models/item-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/home.dart';
import 'package:service/screens/menu-page.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptInput extends StatefulWidget {
  @override
  _ReceiptInputState createState() => _ReceiptInputState();
}

class _ReceiptInputState extends State<ReceiptInput> {
  final _key = GlobalKey<FormState>();

  bool checkValue = false;

  TextStyle header = GoogleFonts.sourceSansPro();

  final controller = Get.put(ReceiptInputController());

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Input Tanda Terima',
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: customCard(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: webCustomCard(),
    );
  }

  Widget customCard() {
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                        DateFormat('d MMMM y', 'id').format(controller.dateTime.value).toString(),
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          DateFormat.jm().format(controller.dateTime.value).toString(),
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  Text('Detail', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onTap: () {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return customerSearchBottomSheet();
                                },
                              );
                            },
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Isi nama customer!';
                              }
                              return null;
                            },
                            controller: controller.customerController,
                            decoration: InputDecoration(labelText: 'Nama Customer'),
                          ),
                        ),
                        Column(
                          children: [
                            CupertinoSwitch(
                              value: controller.isNewCustomer.value,
                              onChanged: (value) {
                                controller.isNewCustomer.value = value;
                                controller.itemId.value = 0;
                                controller.customerController.clear();
                                controller.phoneNumberController.clear();
                                controller.addressController.clear();
                              },
                              activeColor: kPrimary,
                            ),
                            Text(
                              'Baru',
                              style: GoogleFonts.sourceSansPro(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  Obx(
                    () {
                      if (controller.isNewCustomer.value == true) {
                        return TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Isi nomor telfon customer!';
                            }
                            return null;
                          },
                          controller: controller.phoneNumberController,
                          decoration: InputDecoration(labelText: 'Nomor Telfon'),
                          keyboardType: TextInputType.number,
                        );
                      }
                      return SizedBox();
                    },
                  ),

                  // SizedBox(height: 20),
                  Obx(() {
                    if (controller.isNewCustomer.value == true) {
                      return TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Isi alamat customer!';
                          }
                          return null;
                        },
                        controller: controller.addressController,
                        decoration: InputDecoration(labelText: 'Alamat'),
                        keyboardType: TextInputType.number,
                      );
                    }
                    return SizedBox();
                  }),
                  SizedBox(height: 10),
                  Obx(
                    () => Row(
                      children: [
                        if (controller.isNewItem.isTrue)
                          Expanded(
                            child: TextFormField(
                              controller: controller.manualItemController,
                              decoration: InputDecoration(labelText: 'Nama Barang Manual'),
                            ),
                          ),
                        if (controller.isNewItem.isFalse)
                          Expanded(
                            child: TextFormField(
                              onTap: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return itemSearchBottomSheet();
                                  },
                                );
                              },
                              readOnly: true,
                              controller: controller.itemController,
                              decoration: InputDecoration(labelText: 'Nama Barang'),
                            ),
                          ),
                        Column(
                          children: [
                            CupertinoSwitch(
                              value: controller.isNewItem.value,
                              onChanged: (value) {
                                controller.isNewItem.value = value;
                                controller.itemId.value = 0;
                                controller.itemController.clear();
                                controller.manualItemController.clear();
                              },
                              activeColor: kPrimary,
                            ),
                            Text(
                              'Baru',
                              style: GoogleFonts.sourceSansPro(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Isi kondisi barang!';
                      }
                      return null;
                    },
                    controller: controller.itemConditionController,
                    decoration: InputDecoration(labelText: 'Kondisi Barang'),
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
                              checkValue = newValue!;
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
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(80, 80, 80, 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_key.currentState!.validate() && checkValue == true) {
                              controller.createOrder();
                            } else if (_key.currentState!.validate() && checkValue == false) {
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
                          child: Text('Simpan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget webCustomCard() {
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Customer & Barang',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: controller.isNewCustomer.isTrue ? true : false,
                        child: Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Isi nama customer!';
                              }
                              return null;
                            },
                            controller: controller.customerController,
                            decoration: InputDecoration(labelText: 'Nama Customer'),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.isNewCustomer.isTrue ? false : true,
                        child: Expanded(
                          child: TextFormField(
                            onTap: () {
                              Get.dialog(itemSearchDialog());
                            },
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Isi nama customer!';
                              }
                              return null;
                            },
                            controller: controller.customerController,
                            decoration: InputDecoration(labelText: 'Nama Customer', hintText: "Pilih Customer"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Obx(
                      () => Visibility(
                        visible: controller.isNewCustomer.isTrue ? true : false,
                        child: Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Isi nomor telfon customer!';
                              }
                              return null;
                            },
                            controller: controller.phoneNumberController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(labelText: 'Nomor Telfon'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 20),
                    // Text('Customer Baru'),
                    // SizedBox(width: 5),
                    // Obx(
                    //   () => CupertinoSwitch(
                    //     activeColor: kPrimary,
                    //     value: controller.isNewCustomer.value,
                    //     onChanged: (value) {
                    //       controller.isNewCustomer.toggle();
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                // SizedBox(height: 20),
                Obx(
                  () => Visibility(
                    visible: controller.isNewCustomer.isTrue ? true : false,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Isi alamat customer!';
                        }
                        return null;
                      },
                      controller: controller.addressController,
                      decoration: InputDecoration(labelText: 'Alamat'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      if (controller.isNewItem.isTrue)
                        Expanded(
                          child: TextFormField(
                            controller: controller.manualItemController,
                            decoration: InputDecoration(labelText: 'Nama Barang Manual'),
                          ),
                        ),
                      if (controller.isNewItem.isFalse)
                        Expanded(
                          child: TextFormField(
                            onTap: () {
                              Get.dialog(itemSearchDialog());
                            },
                            readOnly: true,
                            controller: controller.itemConditionController,
                            decoration: InputDecoration(labelText: 'Nama Barang'),
                          ),
                        ),
                      Column(
                        children: [
                          CupertinoSwitch(
                            value: controller.isNewItem.value,
                            onChanged: (value) {
                              controller.isNewItem.value = value;
                              controller.itemId.value = 0;
                              controller.itemController.clear();
                              controller.manualItemController.clear();
                            },
                            activeColor: kPrimary,
                          ),
                          Text(
                            'Baru',
                            style: GoogleFonts.sourceSansPro(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Isi kondisi barang!';
                    }
                    return null;
                  },
                  controller: controller.itemConditionController,
                  decoration: InputDecoration(labelText: 'Kondisi Barang'),
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
                            checkValue = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Terima '),
                    InkWell(
                      onTap: () {
                        Get.dialog(TermAndCondition());
                      },
                      child: Text('Syarat dan Ketentuan', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(80, 80, 80, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (_key.currentState!.validate() && checkValue == true) {
                          controller.createOrder();
                        } else if (_key.currentState!.validate() && checkValue == false) {
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
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemSearchBottomSheet() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.clear),
              ),
              title: Text(
                'Cari Barang',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (String value) {
                controller.itemSearch.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Cari barang',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: controller.itemFuture,
                builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
                  if (snapshot.hasData) {
                    controller.itemList.value = snapshot.data!;
                    if (snapshot.data!.isEmpty) return Text('Terjadi Kesalahan');
                    return Obx(
                      () {
                        if (controller.itemList.isEmpty) return Center(child: Text('Barang tidak ditemukan'));
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: controller.itemList.length,
                          itemBuilder: (context, index) {
                            final item = controller.itemList[index];
                            return ListTile(
                              onTap: () {
                                controller.itemController.text = item.itemName!;
                                controller.itemId.value = item.id!;
                                Get.back();
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(item.itemName!),
                              subtitle: Text(item.itemAlias!),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customerSearchBottomSheet() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.clear),
              ),
              title: Text(
                'Cari Customer',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (String value) {
                controller.customerSearch.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Cari customer',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: controller.customerFuture,
                builder: (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
                  if (snapshot.hasError) return Text('Terjadi Kesalahan');
                  if (snapshot.hasData) {
                    controller.customerList.value = snapshot.data!;
                    return Obx(
                      () {
                        if (controller.customerList.isEmpty) return Center(child: Text('Barang tidak ditemukan'));
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: controller.customerList.length,
                          itemBuilder: (context, index) {
                            final customer = controller.customerList[index];
                            return ListTile(
                              onTap: null,
                              contentPadding: EdgeInsets.zero,
                              title: Text(customer.name!),
                              subtitle: Text('${customer.contact!}'),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Dialog itemSearchDialog() {
    return Dialog(
      child: Container(
        height: Get.height,
        width: Get.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cari Barang',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (String value) {
                  controller.itemSearch.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'Cari barang',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<ItemModel>>(
                  future: controller.itemFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      controller.itemList.value = snapshot.data!;
                      if (snapshot.data!.isEmpty) return Text('Terjadi Kesalahan');
                      return Obx(
                        () {
                          if (controller.itemList.isEmpty) return Center(child: Text('Barang tidak ditemukan'));
                          return ListView.separated(
                            itemCount: controller.itemList.length,
                            itemBuilder: (context, index) {
                              final item = controller.itemList[index];
                              return ListTile(
                                onTap: () {
                                  controller.itemController.text = item.itemName!;
                                  controller.itemId.value = item.id!;
                                  Get.back();
                                },
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.itemName!),
                                subtitle: Text(item.itemAlias!),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
