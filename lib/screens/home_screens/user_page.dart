import 'package:covid_scan/screens/home_screens/user_visits.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:covid_scan/screens/home_screens/scan_qr.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: kAppPrimColor),
        backgroundColor: kAppPrimColor,
        title: Text('Lets Battle Covid'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff6a1b9a), Color(0xff4a148c)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 4,
                      color: Colors.black54,
                    )
                  ]),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QrScanner(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage('assets/images/qr-scan.png'),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tap to Scan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => UserVisits()));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xffc2185b), Color(0xff4a148c)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'View your Visits',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900),
                    ),
                    Image(
                      image: AssetImage('assets/images/userData.png'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
