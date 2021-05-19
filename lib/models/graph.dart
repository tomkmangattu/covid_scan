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

  final List<int> dailyNo = [0, 0, 0, 0];

  final _now = visitsdateFormator.format(DateTime.now());
  final _pre1 =
      visitsdateFormator.format(DateTime.now().subtract(Duration(days: 1)));
  final _pre2 =
      visitsdateFormator.format(DateTime.now().subtract(Duration(days: 2)));
  final _pre3 =
      visitsdateFormator.format(DateTime.now().subtract(Duration(days: 3)));

  void _getCustNo() async {
    print(_pre1);
    final data = await fireStoreShopRef.doc(_now).collection(_now).get();
    final data1 = await fireStoreShopRef.doc(_pre1).collection(_pre1).get();
    final data2 = await fireStoreShopRef.doc(_pre2).collection(_pre2).get();
    final data3 = await fireStoreShopRef.doc(_pre3).collection(_pre3).get();
    setState(() {
      dailyNo[0] = data3.docs.length;
      dailyNo[1] = data2.docs.length;
      dailyNo[2] = data1.docs.length;
      dailyNo[3] = data.docs.length;
    });

    print(dailyNo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Statics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
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
              painter: MyPainter(dailyNo: dailyNo),
            );
          }),
        ),
        Text(
          'Customer Statics of 4 days',
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final List<int> dailyNo;
  MyPainter({this.dailyNo});

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
      ..color = Color(0xff64ffda)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final paintLine = Paint()
      ..color = Color(0xff00e676)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final origin = Offset(0, size.height);
    final yaxis = Offset(0, 0);
    final xaxis = Offset(size.width, size.height);
    final p1 = Offset(unitW, size.height - unitH * dailyNo[0]);
    final p2 = Offset(unitW * 2, size.height - unitH * dailyNo[1]);
    final p3 = Offset(unitW * 3, size.height - unitH * dailyNo[2]);
    final p4 = Offset(unitW * 4, size.height - unitH * dailyNo[3]);
    // axis
    // canvas.drawLine(
    //     origin - Offset(0, unitW / 2), yaxis + Offset(0, unitW / 2), paint);
    // canvas.drawLine(
    //     origin + Offset(unitW / 2, 0), xaxis - Offset(unitW / 2, 0), paint);
    // graph
    List<TextPainter> pantxt = [];
    for (final no in dailyNo) {
      final sp =
          TextSpan(text: no.toString(), style: TextStyle(color: Colors.grey));
      pantxt.add(TextPainter(text: sp, textDirection: TextDirection.ltr));
    }
    for (int i = 0; i < pantxt.length; i++) {
      pantxt[i].layout(minWidth: 0, maxWidth: size.width);
    }
    pantxt[0].paint(canvas, origin);
    canvas.drawLine(origin, p1, paintLine);
    canvas.drawCircle(origin, 4, paint);
    canvas.drawLine(p1, p2, paintLine);
    canvas.drawCircle(p1, 4, paint);
    canvas.drawLine(p2, p3, paintLine);
    canvas.drawCircle(p2, 4, paint);
    canvas.drawLine(p3, p4, paintLine);
    canvas.drawCircle(p3, 4, paint);
    canvas.drawCircle(p4, 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
