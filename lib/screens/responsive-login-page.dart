import 'package:flutter/material.dart';
import 'package:service/responsive.dart';
import 'package:service/screens/login.dart';

class ResponsiveLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Login(),
      ),
      tablet: Center(
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(child: Login(), flex: 2),
            Spacer(flex: 1),
          ],
        ),
      ),
      web: Center(
        child: Row(
          children: [
            Spacer(flex: 1),
            Expanded(child: Login(), flex: 1),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
