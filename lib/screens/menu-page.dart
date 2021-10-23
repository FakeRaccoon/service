import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/controllers/home-controller.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/payment-page.dart';
import 'package:service/screens/service-proposal-page.dart';
import 'package:service/screens/Sparepart/sparepart-page.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/screens/receipt_input.dart';

import '../componen/menu-card.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
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
                  tooltip: 'Logout',
                  color: Colors.black,
                  onPressed: () {},
                  icon: Icon(Icons.exit_to_app_rounded),
                ),
                SizedBox(width: 20),
              ],
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuCard(
            cardTitle: 'Resepsionis',
            menuList: [
              {
                'menu': 'Pengajuan Service',
                'ontap': () => Get.to(() => ReceiptInput()),
              },
              {
                'menu': 'Proposal Service',
                'ontap': () => Get.to(() => ServiceProposal()),
              }
            ],
          ),
          MenuCard(
            cardTitle: 'Teknisi',
            menuList: [
              {'menu': 'Service', 'ontap': () => Get.to(() => TechnicianPage())},
            ],
          ),
          MenuCard(
            cardTitle: 'Sparepart',
            menuList: [
              {'menu': 'Sparepart', 'ontap': () => Get.to(() => SparePartPage())},
            ],
          ),
          MenuCard(
            cardTitle: 'Pembayaran',
            menuList: [
              {'menu': 'Pembayaran', 'ontap': () => Get.to(() => PaymentPage())},
            ],
          ),
        ],
      ),
    );
  }
}
