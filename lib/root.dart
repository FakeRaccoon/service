import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service/models/user-model.dart';
import 'package:service/screens/home.dart';
import 'package:service/screens/responsive-login-page.dart';
import 'package:service/services/api.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    // return Center(child: CircularProgressIndicator());
    return Scaffold(
      body: FutureBuilder(
        future: APIService().userDetail(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) return Home(user: snapshot.data!);
          if (snapshot.hasError) return ResponsiveLoginPage();
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
