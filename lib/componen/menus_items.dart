import 'dart:ffi';

import 'package:flutter/material.dart';

class MenusItems extends StatelessWidget {
  final icon;
  final String text;
  final onTap;

  const MenusItems({Key key, @required this.icon, @required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: icon,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
          ),
          SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
