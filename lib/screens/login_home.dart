import 'package:covid_scan/screens/generate_qr.dart';
import 'package:covid_scan/screens/scan_qr.dart';
import 'package:flutter/material.dart';

class LoginHome extends StatelessWidget {
  static const String id = 'login home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, QrGeneratorPage.id);
            },
            child: Text('generate or code'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, QrScanner.id);
            },
            child: Text('read qr code'),
          ),
        ],
      ),
    );
  }
}
