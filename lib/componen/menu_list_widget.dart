import 'package:flutter/material.dart';
import 'package:service/componen/menus_card.dart';

class MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
