import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/home.dart';
import 'package:service/login.dart';
import 'package:service/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(behavior: MyBehavior(), child: child);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.grey[900]),
        primaryColor: Colors.black,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.black,
        textSelectionColor: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
