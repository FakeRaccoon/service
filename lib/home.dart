import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service/componen/menus_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber),
      Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.red),
      Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.cyan),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white,
                height: 40,
                width: MediaQuery.of(context).size.width * .68,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero),
                ),
              ),
            ),
            Icon(Icons.api),
            Icon(Icons.person),
            Icon(Icons.notifications)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      disableCenter: true,
                      onPageChanged: (index, value) {
                        setState(() {
                          current = index;
                        });
                      }),
                  items: list,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: list.map((url) {
                    int index = list.indexOf(url);
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: current == index
                            ? Color.fromRGBO(255, 255, 255, 0.9)
                            : Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 10),
                MenuCard(
                  icon: '033-money.svg',
                  title: 'Tanda Terima Service',
                ),
                MenuCard(
                  icon: '042-gift-card.svg',
                  title: 'List Part & Biaya',
                ),
                MenuCard(
                  icon: '016-gear.svg',
                  title: 'List Part & Biaya',
                ),
                MenuCard(
                  icon: '043-coupon.svg',
                  title: 'List Part & Biaya',
                ),
                MenuCard(
                  icon: '044-open.svg',
                  title: 'List Part & Biaya',
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * .13,
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      color: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .40,
                      color: Colors.lightGreen,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
