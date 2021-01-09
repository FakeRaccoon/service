import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/screens/cart.dart';
import 'package:service/screens/receipt.dart';
import 'package:service/screens/receipt_input.dart';
import 'package:service/screens/tech.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Container(
                  child: InkWell(
                    onTap: () => Get.to(ReceiptInput()),
                    child: Card(
                      child: Center(child: Text('receipt input')),
                    ),
                  ),
                  width: mediaQ.width / 2,
                  height: mediaQ.height * .25,
                ),
                Container(
                  child: InkWell(
                    onTap: () => Get.to(Tech()),
                    child: Card(
                      child: Center(child: Text('Teknisi')),
                    ),
                  ),
                  width: mediaQ.width / 2,
                  height: mediaQ.height * .25,
                ),
                Container(
                  child: InkWell(
                    onTap: () => Get.to(Receipt()),
                    child: Card(
                      child: Center(child: Text('receipt')),
                    ),
                  ),
                  width: mediaQ.width / 2,
                  height: mediaQ.height * .25,
                ),
                Container(
                  child: InkWell(
                    onTap: () => Get.to(Cart()),
                    child: Card(
                      child: Center(child: Text('part and fees')),
                    ),
                  ),
                  width: mediaQ.width / 2,
                  height: mediaQ.height * .25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
