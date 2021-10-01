import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/models/order-detail-model.dart';
import 'package:service/models/order-model.dart';
import 'package:service/responsive.dart';
import 'package:service/services/api.dart';

class ServiceProposal extends StatefulWidget {
  const ServiceProposal({Key? key}) : super(key: key);

  @override
  _ServiceProposalState createState() => _ServiceProposalState();
}

class _ServiceProposalState extends State<ServiceProposal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !Responsive.isMobile(context)
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Service Proposal',
                style: GoogleFonts.sourceSansPro(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      body: FutureBuilder<List<Order>>(
        future: APIService().getOrder(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('Tidak ada data'),
              );
            }
            if (Responsive.isMobile(context)) {
              return OrderList(orders: snapshot.data!);
            }
            return Container(
              height: Get.height * .70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: OrderList(orders: snapshot.data!),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  final List<Order> orders;
  const OrderList({Key? key, required this.orders}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late List<Order> data;

  int currentPage = 1;
  bool hasMore = false;

  late ScrollController scrollController;

  TextStyle header = GoogleFonts.sourceSansPro();
  TextStyle content = GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold);

  Future<void> refresh() async {
    final order = await APIService().getOrder();
    setState(() {
      data = order;
    });
  }

  @override
  void initState() {
    super.initState();
    data = widget.orders;
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        final value = await APIService().getOrder(page: currentPage + 1);
        if (value.isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            currentPage++;
            hasMore = true;
            data.addAll(value);
          });
        }
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
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        itemCount: hasMore ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == data.length) {
            return _buildProgressIndicator();
          }
          final convert = data[index].status;
          late String status;
          switch (convert) {
            case 0:
              status = 'Cek Teknisi';
              break;
          }
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status ?? '',
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    onTap: () => Get.to(
                      () => ResponsiveServiceProposalPage(
                        id: data[index].id!,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(data[index].item!.itemName, style: content),
                    subtitle: Row(
                      children: [
                        Icon(Icons.date_range_rounded, color: Colors.grey[600]),
                        SizedBox(width: 5),
                        Text(DateFormat('d MMMM y').format(data[index].createdAt!), style: header),
                      ],
                    ),
                    trailing: Text(data[index].customer!.name!, style: header),
                  ),
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

class ResponsiveServiceProposalPage extends StatelessWidget {
  const ResponsiveServiceProposalPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(),
      tablet: ServiceProposalDetail(id: id),
      web: Scaffold(
        body: Center(
          child: Container(
            width: 1200,
            child: ServiceProposalDetail(id: id),
          ),
        ),
      ),
    );
  }
}

class ServiceProposalDetail extends StatefulWidget {
  final int id;

  const ServiceProposalDetail({Key? key, required this.id}) : super(key: key);
  @override
  _ServiceProposalDetailState createState() => _ServiceProposalDetailState();
}

class _ServiceProposalDetailState extends State<ServiceProposalDetail> {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Proposal Service',
          style: GoogleFonts.sourceSansPro(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<OrderDetail>(
        future: APIService().getOrderDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final order = snapshot.data;
            return SingleChildScrollView(
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
                              Text(
                                'TANGGAL TERIMA',
                                style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'JAM',
                                style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat('d MMMM y').format(snapshot.data!.createdAt!).toString(),
                                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Spacer(),
                              Text(DateFormat.jm().format(DateTime.now()).toString(),
                                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'TANGGAL SELESAI',
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            DateFormat('d MMMM y').format(DateTime.now()).toString(),
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'MASALAH',
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            order!.problem ?? '-',
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
                          Text(
                            'BIAYA PART',
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          if (order.orderItems!.isNotEmpty)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: order.orderItems!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(order.orderItems![index].item!.itemName!),
                                  subtitle: Text('Rp ${currency.format(order.orderItems![index].price ?? 0)}'),
                                  trailing: Text('x${order.orderItems![index].qty ?? 0}'),
                                );
                              },
                            ),
                          // SizedBox(height: 10),
                          // Text('BIAYA',
                          //     style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Biaya Perbaikan'),
                            trailing: Text('Rp ${currency.format(order.payment?.repairFee ?? 0)}'),
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
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
