import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMenuCard extends StatelessWidget {
  final String title;
  final onTap;
  final icon;

  const HomeMenuCard({Key key, @required this.title, this.onTap, @required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              leading: icon,
              title: Text(title,
                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
              trailing: Icon(Icons.arrow_forward_ios, size: 25, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
