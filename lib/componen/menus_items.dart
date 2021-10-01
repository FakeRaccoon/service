import 'package:flutter/material.dart';

class MenusItems extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function() onTap;

  const MenusItems({Key? key, required this.icon, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
