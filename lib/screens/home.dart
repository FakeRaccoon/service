import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/controllers/home-controller.dart';
import 'package:service/models/user-model.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/service-proposal-page.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/screens/menu-page.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/services/api.dart';
import 'package:service/style.dart';

import 'Sparepart/sparepart-page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: APIService().userDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Responsive(
            mobile: Scaffold(
                appBar: AppBar(
                  backwardsCompatibility: false,
                  backgroundColor: Colors.white,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
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
                      onPressed: () {},
                      icon: Icon(Icons.exit_to_app_rounded),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                body: Menu()),
            tablet: Scaffold(
              body: Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Menu(), flex: 1),
                    if (controller.viewIndex.value == 0) Expanded(child: HomeTabView(), flex: 2),
                    // if (controller.viewIndex.value == 1) Expanded(child: ServiceProposal(), flex: 2),
                  ],
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
                                  title: Text(snapshot.data!.name!),
                                  subtitle: Text(snapshot.data!.role!.name),
                                  trailing: IconButton(
                                    tooltip: 'Logout',
                                    icon: Icon(Icons.exit_to_app),
                                    onPressed: () => APIService().logout(),
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
              tabs: controller.tabs
                  .map((e) => Tab(child: Text(e, style: GoogleFonts.sourceSansPro(color: Colors.black))))
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              children: [
                ReceiptInput(),
                ServiceProposal(),
                TechnicianPage(),
                SparePartPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
