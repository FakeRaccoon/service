import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/models/order-model.dart';
import 'package:service/sercvices/api.dart';

class ServiceProposal extends StatefulWidget {
  const ServiceProposal({Key key}) : super(key: key);

  @override
  _ServiceProposalState createState() => _ServiceProposalState();
}

class _ServiceProposalState extends State<ServiceProposal> {
  final key = GlobalKey();

  bool isLoading = true;
  OrderModel order;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Service Proposal',
          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: APIService().getOrder(1, null),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Data Kosong'),
              );
            }
            return OrderList(order: snapshot.data, key: key);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  final OrderModel order;
  const OrderList({Key key, this.order}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Datum> data;

  int currentPage = 1;
  bool hasMore = false;

  ScrollController scrollController = ScrollController();

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  Future refresh() async {
    APIService().getOrder(1, null).then((value) {
      OrderModel value;
      setState(() {
        data = value.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.order.data;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        APIService().getOrder(currentPage + 1, null).then((value) {
          if (value.data.isEmpty) {
            setState(() {
              hasMore = false;
            });
          } else {
            setState(() {
              currentPage++;
              hasMore = true;
              data.addAll(value.data);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: hasMore ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == data.length) {
            return _buildProgressIndicator();
          }
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(data[index].item ?? '-', style: content),
                    subtitle: Row(
                      children: [
                        Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                        SizedBox(width: 5),
                        Text(DateFormat('d MMMM y').format(data[index].createdAt) ?? '-', style: header),
                      ],
                    ),
                    trailing: Text(data[index].customer.name ?? '-', style: header),
                  ),
                  // Text(data[index].item ?? '-', style: content),
                  // SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Icon(Icons.date_range_rounded),
                  //     SizedBox(width: 5),
                  //     Text(DateFormat('d MMMM y').format(data[index].createdAt) ?? '-', style: header),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  // Text('Kontak', style: header),
                  // Text('${data[index].customer.contact}' ?? '-', style: content),
                  // SizedBox(height: 10),
                  // Text('Barang', style: header),
                  // Text(data[index].item ?? '-', style: content),
                  // SizedBox(height: 10),
                  // Text('Masalah Mesin', style: header),
                  // Text(data[index].problem ?? '-', style: content),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}

class ServiceProposalDetail extends StatefulWidget {
  @override
  _ServiceProposalDetailState createState() => _ServiceProposalDetailState();
}

class _ServiceProposalDetailState extends State<ServiceProposalDetail> {
  Future onRefresh() async {
    setState(() {});
  }

  bool isChecked = false;
  bool checkValue = false;

  NumberFormat currency = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
