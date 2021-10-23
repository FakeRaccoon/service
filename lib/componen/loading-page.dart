import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingPage extends StatelessWidget {
  final String message;
  const LoadingPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Mohon menunggu', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(message, style: GoogleFonts.sourceSansPro()),
          ],
        ),
      ),
    );
  }
}