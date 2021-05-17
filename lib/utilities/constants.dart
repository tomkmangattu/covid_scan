import 'package:flutter/material.dart';

// app primary color
const Color kAppPrimColor = Color(0xff2979ff);

final BoxDecoration kLoginButtonDec = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
        blurRadius: 3,
        offset: Offset(3, 3),
        spreadRadius: 1,
        color: Colors.black26)
  ],
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff1d39b6), Color(0xff1de9b6)],
  ),
);

final InputDecoration formdecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Color(0xff1d39b6), width: 3),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: kAppPrimColor, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red, width: 3),
  ),
  suffixStyle: TextStyle(color: Colors.red),
);

//Color(0xff1de9b6)
//Color(0xff00e5ff)
//Color(0xff00b8d4)
