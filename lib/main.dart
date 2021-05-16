import 'package:covid_scan/screens/generate_qr.dart';
import 'package:covid_scan/screens/login_home.dart';
import 'package:covid_scan/screens/scan_qr.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginHome.id,
      routes: {
        LoginHome.id: (context) => LoginHome(),
        QrGeneratorPage.id: (context) => QrGeneratorPage(),
        QrScanner.id: (context) => QrScanner(),
      },
    );
  }
}
