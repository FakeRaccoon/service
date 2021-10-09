import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service/responsive.dart';
import 'package:service/root.dart';
import 'package:service/screens/Sparepart/sparepart-detail-page.dart';
import 'package:service/screens/Sparepart/sparepart-page.dart';
import 'package:service/screens/Technician/technician-detail-page.dart';
import 'package:service/screens/Technician/technician-page.dart';
import 'package:service/screens/home.dart';
import 'package:service/screens/login.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/screens/responsive-login-page.dart';
import 'package:service/screens/service-proposal-page.dart';
import 'package:service/style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = GetStorage();
  MyApp() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(behavior: MyBehavior(), child: child!);
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('id'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: kPrimary),
        splashColor: Colors.transparent,
        focusColor: Colors.black,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: storage.hasData('token') ? '/' : '/login',
      getPages: [
        GetPage(name: '/', page: () => Root()),
        GetPage(name: '/login', page: () => ResponsiveLoginPage()),
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/input', page: () => ReceiptInput()),
        GetPage(name: '/proposal', page: () => ServiceProposal()),
        GetPage(name: '/proposal/detail', page: () => ResponsiveServiceProposalPage()),
        GetPage(name: '/service', page: () => TechnicianPage()),
        GetPage(name: '/service/detail', page: () => ResponsiveTechnicianDetailPage()),
        GetPage(name: '/part', page: () => SparePartPage()),
        GetPage(name: '/part/detail', page: () => ResponsiveSparePartDetailPage()),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
