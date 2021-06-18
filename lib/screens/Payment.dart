import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static const scrollPhysic = const ExtentScrollPhysics(itemExtent: 115, separatorSpacing: 20);
  final items = List.generate(10, (index) => '$index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Pembayaran', style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                physics: scrollPhysic,
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => SizedBox(
                  width: scrollPhysic.itemExtent,
                  child: Card(
                    child: Container(
                      width: Get.width,
                      child: ListTile(
                        title: Text('${items[index]}'),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: scrollPhysic.dividerSpacing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtentScrollPhysics extends ScrollPhysics {
  final double itemExtent;
  final double dividerSpacing;

  const ExtentScrollPhysics({ScrollPhysics parent, this.itemExtent, double separatorSpacing})
      : assert(itemExtent != null && itemExtent > 0),
        dividerSpacing = separatorSpacing ?? 0,
        super(parent: parent);

  @override
  ExtentScrollPhysics applyTo(ScrollPhysics ancestor) {
    return ExtentScrollPhysics(
      parent: buildParent(ancestor),
      itemExtent: itemExtent,
      separatorSpacing: dividerSpacing,
    );
  }

  double _getItem(ScrollPosition position) {
    return position.pixels / (itemExtent + dividerSpacing);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * (itemExtent + dividerSpacing);
  }

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getItem(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity) page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);

    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
