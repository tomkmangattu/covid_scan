import 'package:flutter/material.dart';
import 'package:covid_scan/utilities/constants.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  void initState() {
    super.initState();
    _getCustNo();
  }

  List<int> dailyNo = [0, 0, 0, 0, 0];

  void _getCustNo() async {
    final _now = visitsdateFormator.format(DateTime.now());
    List<String> dates = [];
    for (int i = 1; i <= 4; i++) {
      dates.add(
        visitsdateFormator.format(
          DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
    var data = await fireStoreShopRef.doc(_now).collection(_now).get();
    var data1 = await fireStoreShopRef.doc(dates[0]).collection(dates[0]).get();
    var data2 = await fireStoreShopRef.doc(dates[1]).collection(dates[1]).get();
    var data3 = await fireStoreShopRef.doc(dates[2]).collection(dates[2]).get();
    var data4 = await fireStoreShopRef.doc(dates[3]).collection(dates[3]).get();

    setState(() {
      dailyNo[0] = data4.docs.length;
      dailyNo[1] = data3.docs.length;
      dailyNo[2] = data2.docs.length;
      dailyNo[3] = data1.docs.length;
      dailyNo[4] = data.docs.length;
    });

    print(dailyNo.toString());
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Statics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: dark ? Colors.white : Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            return CustomPaint(
              size: Size(height, width),
              painter: MyPainter(dailyNo: dailyNo, dark: dark),
            );
          }),
        ),
        Text(
          'Customer Statics of 5 days',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final List<int> dailyNo;
  final bool dark;
  MyPainter({this.dailyNo, this.dark});

  int _getUnitHeight() {
    int unitHeight = dailyNo[0];
    for (int item in dailyNo) {
      if (unitHeight < item) {
        unitHeight = item;
      }
    }
    return unitHeight == 0 ? 1 : unitHeight;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final unitH = size.height / _getUnitHeight();
    final unitW = size.width / 4;
    final paint = Paint()
      ..color = dark ? Colors.amber : Color(0xffdc7633)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final paintLine = Paint()
      ..color = dark ? Colors.amberAccent : Color(0xffedbb99)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    List<Offset> point = [];
    for (int i = 0; i <= 4; i++) {
      point.add(Offset(unitW * i, size.height - unitH * dailyNo[i]));
    }

    List<TextPainter> pantxt = [];
    for (final no in dailyNo) {
      final sp = TextSpan(
          text: no.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 10));
      pantxt.add(TextPainter(text: sp, textDirection: TextDirection.ltr));
    }

    for (int i = 0; i <= 4; i++) {
      pantxt[i].layout(minWidth: 0, maxWidth: size.width);
      pantxt[i].paint(canvas, point[i] + Offset(4, 0));

      if (i != 4) canvas.drawLine(point[i], point[i + 1], paintLine);
      canvas.drawCircle(point[i], 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
