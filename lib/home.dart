import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/componen/menus_items.dart';
import 'package:service/root.dart';
import 'package:service/screens/Payment.dart';
import 'package:service/screens/sparepart.dart';
import 'package:service/screens/ServiceProposal.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/screens/tech.dart';
import 'package:service/screens/users.dart';
import 'package:service/sercvices/api.dart';
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
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Menus', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          InkWell(
            onTap: () {
              APIService().logout().then((value) async {
                if (value['status'] == 200) {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  Get.offAll(() => Root());
                }
              });
            },
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
          ],
        ),
      ),
    );
  }
}
