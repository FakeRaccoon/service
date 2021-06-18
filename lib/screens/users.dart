import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service/componen/custom_button.dart';
import 'package:service/root.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final username = sharedPreferences.getString('name');
    final role = sharedPreferences.getString('role');
    if (username != null) {
      setState(() {
        name = username;
        userRole = role;
      });
      print(name);
    } else {
      Get.offAll(Root());
    }
  }

  Future logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();
  }

  String name;
  String userRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Akun Saya', style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'User Info',
            //   style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: ListTile(
                title: Text(name ?? '', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                subtitle: Text(userRole ?? ''),
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Superuser', style: GoogleFonts.sourceSansPro()),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Manage Users', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(thickness: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Log', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onTap: () => logout().then((value) => getUserInfo()),
              color: Colors.amber,
              title: 'Konfirmasi',
            )
          ],
        ),
      ),
    );
  }
}
