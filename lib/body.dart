import 'package:flutter/material.dart';
import 'package:service/screens/menu-page.dart';
import 'package:service/screens/users.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedPage = 0;
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    pageList.add(Menu());
    pageList.add(Users());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.amber,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
