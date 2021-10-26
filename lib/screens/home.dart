import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/controllers/home-controller.dart';
import 'package:service/models/user-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/final-transaction.dart';
import 'package:service/screens/service-proposal-page.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/screens/menu-page.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';

import 'Sparepart/sparepart-page.dart';

class Home extends StatefulWidget {
  final User? user;

  const Home({Key? key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(HomeController());
  @override
  void initState() {
    controller.user = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIService().userDetail(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Responsive(
            mobile: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    'Menus',
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    IconButton(
                      color: Colors.black,
                      onPressed: () => controller.logout(),
                      icon: Icon(Icons.exit_to_app_rounded),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                body: Menu()),
            tablet: Scaffold(
              backgroundColor: Colors.white,
              body: Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(snapshot.data!.name!.split(' ').map((e) => e.capitalize).join(' ')),
                                    subtitle: Text(snapshot.data!.role!.name),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: Get.width,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          APIService().logout();
                                        },
                                        child: Text('Logout'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                          if (controller.viewIndex.value == 0) Expanded(child: HomeTabView(), flex: 3),
                          // if (controller.viewIndex.value == 0) Expanded(child: ReceiptInput(), flex: 2),
                          // if (controller.viewIndex.value == 1) Expanded(child: ServiceProposal(), flex: 2),
                          // if (controller.viewIndex.value == 2) Expanded(child: TechnicianPage(), flex: 2),
                          // if (controller.viewIndex.value == 3) Expanded(child: SparePartPage(), flex: 2),
                        ],
                      ),
                    ),
              ),
            ),
            web: Scaffold(
              backgroundColor: Colors.white,
              body: Obx(
                () => Center(
                  child: Container(
                    width: 1200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(snapshot.data!.name!.split(' ').map((e) => e.capitalize).join(' ')),
                                  subtitle: Text(snapshot.data!.role!.name),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width: Get.width,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        APIService().logout();
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                        if (controller.viewIndex.value == 0) Expanded(child: HomeTabView(), flex: 3),
                        // if (controller.viewIndex.value == 0) Expanded(child: ReceiptInput(), flex: 2),
                        // if (controller.viewIndex.value == 1) Expanded(child: ServiceProposal(), flex: 2),
                        // if (controller.viewIndex.value == 2) Expanded(child: TechnicianPage(), flex: 2),
                        // if (controller.viewIndex.value == 3) Expanded(child: SparePartPage(), flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class HomeTabView extends StatelessWidget {
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: TabBar(
              indicatorColor: kPrimary,
              controller: controller.tabController,
              labelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: controller.tabs.map((e) => Tab(child: Text(e))).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              children: [
                ReceiptInput(),
                ServiceProposal(),
                FinalTransaction(),
                // SparePartPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
