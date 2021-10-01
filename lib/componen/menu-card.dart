import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/style.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    required this.cardTitle,
    required this.menuList,
  });

  final String cardTitle;
  final List<Map<dynamic, dynamic>> menuList;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCorner)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Color(0xff7c7c7c)),
            ),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              itemCount: menuList.length,
              itemBuilder: (context, index) => ListTile(
                onTap: menuList[index]['ontap'],
                contentPadding: EdgeInsets.zero,
                title: Text(
                  menuList[index]['menu'],
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
              separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
            ),
          ],
        ),
      ),
    );
  }
}
