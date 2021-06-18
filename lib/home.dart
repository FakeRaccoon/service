import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/componen/menus_items.dart';
import 'package:service/screens/Payment.dart';
import 'package:service/screens/sparepart.dart';
import 'package:service/screens/ServiceProposal.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/screens/tech.dart';
import 'package:service/screens/users.dart';
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
    final _pageList = sharedPreferences.getStringList('pageList');
    final _pageCategoryList = sharedPreferences.getStringList('pageCategoryList');
    if (_name != null) {
      setState(() {
        name = _name;
        pageList = _pageList;
        pageCategoryList = _pageCategoryList;
      });
    }
  }

  List<String> pageList = [];
  List<String> pageCategoryList = [];

  ExpandableController receptionistController = ExpandableController();
  ExpandableController technicianController = ExpandableController();

  String name;

  int activeMeterIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Menus', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          InkWell(
            onTap: () => Get.to(() => Payment()),
            child: Container(
              width: Get.width * .10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffBDBDC7)),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: Get.width * .07,
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resepsionis',
                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Color(0xff7c7c7c)),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      onTap: () => Get.to(() => ReceiptInput()),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Input Tanda Terima',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffBDBDC7)),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Divider(thickness: 1),
                    ListTile(
                      onTap: () => Get.to(() => ServiceProposal()),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Proposal Biaya',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffBDBDC7)),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teknisi',
                      style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Color(0xff7c7c7c)),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      onTap: () => Get.to(() => Tech()),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Service',
                        style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffBDBDC7)),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ExpansionPanelList.radio(
            //   elevation: 0,
            //   children: [
            //     ExpansionPanelRadio(
            //       canTapOnHeader: true,
            //       backgroundColor: Colors.transparent,
            //       value: 1,
            //       headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            //         title: Text('Menu 1', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
            //       ),
            //       body: GridView.count(
            //         physics: NeverScrollableScrollPhysics(),
            //         childAspectRatio: .90,
            //         crossAxisSpacing: 1,
            //         mainAxisSpacing: 1,
            //         shrinkWrap: true,
            //         crossAxisCount: 4,
            //         children: [
            //           MenusItems(
            //             icon: Icon(Icons.book),
            //             text: 'Input tanda terima',
            //             onTap: () => Get.to(() => ReceiptInput()),
            //           ),
            //           MenusItems(
            //             icon: Icon(Icons.library_books),
            //             text: 'Proposal biaya',
            //             onTap: () => Get.to(() => ServiceProposal()),
            //           ),
            //         ],
            //       ),
            //     ),
            //     ExpansionPanelRadio(
            //       canTapOnHeader: true,
            //       backgroundColor: Colors.transparent,
            //       value: 2,
            //       headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            //         title: Text('Menu 2', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
            //       ),
            //       body: GridView.count(
            //         physics: NeverScrollableScrollPhysics(),
            //         childAspectRatio: .90,
            //         crossAxisSpacing: 1,
            //         mainAxisSpacing: 1,
            //         shrinkWrap: true,
            //         crossAxisCount: 4,
            //         children: [
            //           MenusItems(icon: FaIcon(FontAwesomeIcons.wrench), text: 'Service', onTap: () => Get.to(Tech())),
            //         ],
            //       ),
            //     ),
            //     ExpansionPanelRadio(
            //       canTapOnHeader: true,
            //       backgroundColor: Colors.transparent,
            //       value: 3,
            //       headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            //         title: Text('Menu 3', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
            //       ),
            //       body: GridView.count(
            //         physics: NeverScrollableScrollPhysics(),
            //         childAspectRatio: .90,
            //         crossAxisSpacing: 1,
            //         mainAxisSpacing: 1,
            //         shrinkWrap: true,
            //         crossAxisCount: 4,
            //         children: [
            //           MenusItems(
            //               icon: FaIcon(FontAwesomeIcons.list), text: 'Part & Biaya', onTap: () => Get.to(SparePart())),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
