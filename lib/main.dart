import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service/responsive.dart';
import 'package:service/root.dart';
import 'package:service/screens/login.dart';
import 'package:service/screens/responsive-login-page.dart';
import 'package:service/style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
      home: storage.hasData('token') ? Root() : ResponsiveLoginPage(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
