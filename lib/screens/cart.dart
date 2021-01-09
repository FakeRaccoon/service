import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service/componen/custom_button.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var currency = NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('CartItems').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          final sum = snapshot.data.docs.fold(0, (s, n) => s + n['price']);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var qty = snapshot.data.docs[index].data()['qty'];
                    var price = snapshot.data.docs[index].data()['price'];
                    var intController = TextEditingController();
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.docs[index].data()['itemName'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                    'Rp ' +
                                        currency.format(
                                            snapshot.data.docs[index].data()['total'] ?? price),
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    splashRadius: 15,
                                    onPressed: () {
                                      var getDocId = snapshot.data.docs[index].id;
                                      FirebaseFirestore.instance
                                          .collection('CartItems')
                                          .doc(getDocId)
                                          .update({"qty": qty - 1});
                                      FirebaseFirestore.instance
                                          .collection('CartItems')
                                          .doc(getDocId)
                                          .update({"total": price / 2});
                                    },
                                    iconSize: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: intController,
                                      keyboardType: TextInputType.number,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(hintText: qty.toString()),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    splashRadius: 15,
                                    onPressed: () {
                                      var getDocId = snapshot.data.docs[index].id;
                                      FirebaseFirestore.instance
                                          .collection('CartItems')
                                          .doc(getDocId)
                                          .update({"qty": qty + 1});
                                      FirebaseFirestore.instance
                                          .collection('CartItems')
                                          .doc(getDocId)
                                          .update({"total": price * qty});
                                    },
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('Total'),
                    Spacer(),
                    Text(
                      'Rp ' + currency.format(sum).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        title: 'Beli',
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Custom extends StatefulWidget {
  final TextEditingController controller;
  final int qty;

  const Custom({Key key, this.qty, this.controller}) : super(key: key);

  @override
  _CustomState createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.controller.text = widget.qty.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        setState(() {
          widget.controller.text = widget.qty.toString();
        });
      },
      controller: widget.controller,
      keyboardType: TextInputType.number,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
    );
  }
}
