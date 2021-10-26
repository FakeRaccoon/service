import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  const SuccessPage({Key? key, required this.message}) : super(key: key);

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
            Container(
              decoration: BoxDecoration(color: Color(0xff8CC24A), shape: BoxShape.circle),
              child: Icon(Icons.check, color: Colors.white, size: 50),
            ),
            SizedBox(height: 10),
            Text('Success!', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(message, style: GoogleFonts.sourceSansPro()),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff8CC24A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Get.offAllNamed('/'),
              child: Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}
