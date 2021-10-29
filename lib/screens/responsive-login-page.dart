import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/login.dart';

class ResponsiveLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: LoginPage(),
      ),
      tablet: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            children: [
              Spacer(flex: 1),
              Expanded(child: LoginPage(), flex: 2),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
      web: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            children: [
              Spacer(flex: 1),
              Expanded(child: LoginPage(), flex: 1),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
