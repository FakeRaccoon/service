import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/componen/home_menu_card.dart';
import 'package:service/componen/menus_items.dart';
import 'package:service/screens/Payment.dart';
import 'package:service/screens/sparepart.dart';
import 'package:service/screens/ServiceProposal.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/screens/tech.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    getUserInfo();
  }

  SharedPreferences sharedPreferences;

  Future getUserInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final _name = sharedPreferences.getString('name');
    if (_name != null) {
      setState(() {
        name = _name;
      });
      print(_name);
    }
  }

  ExpandableController receptionistController = ExpandableController();
  ExpandableController technicianController = ExpandableController();

  String name;

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Menus',
          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          ExpandablePanel(
            theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Resepsionis', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            expanded: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: .90,
              crossAxisSpacing: 1,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                MenusItems(icon: Icon(Icons.book), text: 'Input tanda terima', onTap: () => Get.to(ReceiptInput())),
                MenusItems(
                    icon: Icon(Icons.library_books), text: 'Proposal biaya', onTap: () => Get.to(ServiceProposal())),
              ],
            ),
          ),
          ExpandablePanel(
            theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Teknisi', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            expanded: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: .90,
              crossAxisSpacing: 1,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                MenusItems(icon: FaIcon(FontAwesomeIcons.wrench), text: 'Service', onTap: () => Get.to(Tech())),
              ],
            ),
          ),
          ExpandablePanel(
            theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Sparepart', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            expanded: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: .90,
              crossAxisSpacing: 1,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                MenusItems(icon: FaIcon(FontAwesomeIcons.list), text: 'Part & biaya', onTap: () => Get.to(SparePart())),
              ],
            ),
          ),
          ExpandablePanel(
            theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
            header: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Pembayaran', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            expanded: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: .90,
              crossAxisSpacing: 1,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                MenusItems(icon: FaIcon(FontAwesomeIcons.moneyBillAlt), text: 'Tunai', onTap: () {}),
                MenusItems(icon: FaIcon(FontAwesomeIcons.creditCard), text: 'Non tunai', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(left: 20),
      //           child: Text(
      //             'Menus',
      //             style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 22),
      //           ),
      //         ),
      //         Column(
      //           children: [
      //             HomeMenuCard(
      //               title: 'Input tanda terima',
      //               icon: FaIcon(FontAwesomeIcons.book),
      //               onTap: () => Get.to(ReceiptInput()),
      //             ),
      //             HomeMenuCard(
      //               title: 'Teknisi',
      //               icon: FaIcon(FontAwesomeIcons.wrench),
      //               onTap: () => Get.to(Tech()),
      //             ),
      //             HomeMenuCard(
      //               title: 'Part dan biaya',
      //               icon: FaIcon(FontAwesomeIcons.boxes),
      //               onTap: () => Get.to(SparePart()),
      //             ),
      //             HomeMenuCard(
      //               title: 'Tanda terima',
      //               icon: FaIcon(FontAwesomeIcons.check),
      //               onTap: () => Get.to(ServiceProposal()),
      //             ),
      //             HomeMenuCard(
      //               title: 'Pembayaran',
      //               icon: FaIcon(FontAwesomeIcons.moneyBillWave),
      //               onTap: () => Get.to(Payment()),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
