import 'package:covid_scan/cubit/login_cubit.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBox extends StatefulWidget {
  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  bool _obscureText = false;
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 30;
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Otp sent to ..' +
                        BlocProvider.of<LoginCubit>(context).phno.substring(8),
                  ),
                  IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: _toggleVisibility,
                  ),
                ],
              ),
              CustomPaint(
                size: Size(width, 1),
                painter: MyPainter(length: width / 9, activeIndex: activeIndex),
                child: TextFormField(
                  obscureText: _obscureText,
                  showCursor: false,
                  onChanged: (value) {
                    setState(() {
                      activeIndex = value.length;
                    });
                    if (value.length == 6) {
                      BlocProvider.of<LoginCubit>(context)
                          .signInWithPhoneNo(value);
                    }
                  },
                  autofocus: true,
                  enableSuggestions: false,
                  style: TextStyle(
                    letterSpacing: width / 9,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(0),
                    counterText: "",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

class MyPainter extends CustomPainter {
  final double length;
  int activeIndex;
  MyPainter({this.length, this.activeIndex});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kAppPrimColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final paintInactive = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
          Offset(i * length + 17 * i + 9, 40),
          Offset((i + 1) * length + 17 * i + 9, 40),
          i > activeIndex ? paintInactive : paint);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex;
  }
}
