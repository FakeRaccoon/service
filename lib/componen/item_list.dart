import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final imageUrl;
  final itemName;
  final price;

  const ItemList({Key key, this.imageUrl, this.itemName, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Container(
      height: 250,
      child: Center(
        child: Container(
          height: 230,
          width: mediaQ.width * .35,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          height: 100,
                          child: Image.network(
                              imageUrl ?? 'https://www.btklsby.go.id/images/placeholder/basic.png',
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '\$$price' ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
