import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.message}) : super(key: key);
  final String message;
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
            Text('Gagal memproses', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(message, style: GoogleFonts.sourceSansPro()),
          ],
        ),
      ),
    );
  }
}
