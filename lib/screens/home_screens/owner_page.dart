import 'package:covid_scan/models/graph.dart';
import 'package:covid_scan/screens/home_screens/generate_qr.dart';
import 'package:covid_scan/screens/home_screens/shop_registor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class OwnerScreen extends StatelessWidget {
  final _qrId = 'covin_scan_u/ ' +
      FirebaseAuth.instance.currentUser.displayName +
      '/ ' +
      FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Battle Covid'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Graph(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: _qrButton(
                      bkColor: dark ? Colors.deepPurple : Colors.transparent,
                      borderColor: Colors.deepPurple,
                      textColor: dark ? Colors.white : Colors.deepPurple,
                      qrColor: dark ? Colors.white60 : Colors.deepPurple,
                      text: 'Generate Qr Code',
                      onpress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QrGeneratorPage(
                              qrCode: _qrId,
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopRegistor(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Image(
                            image: AssetImage('assets/images/data.png'),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Customer Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextButton _qrButton(
      {Color borderColor,
      String text,
      Color textColor,
      Color bkColor,
      Color qrColor,
      Function onpress}) {
    return TextButton(
      onPressed: onpress,
      child: Container(
        decoration: BoxDecoration(
          color: bkColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: QrImage(
                data: _qrId,
                foregroundColor: qrColor,
              )),
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
