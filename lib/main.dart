import 'package:covid_scan/screens/home_screens/generate_qr.dart';

import 'package:covid_scan/screens/home_screens/app_home.dart';
import 'package:covid_scan/screens/login_home.dart';
import 'package:covid_scan/screens/new_user.dart';
import 'package:covid_scan/screens/phone_no.dart';
import 'package:covid_scan/screens/home_screens/scan_qr.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(primaryColor: kAppPrimColor),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginHome.id
          : AppHomePage.id,
      routes: {
        LoginHome.id: (context) => LoginHome(),
        QrGeneratorPage.id: (context) => QrGeneratorPage(),
        QrScanner.id: (context) => QrScanner(),
        LoginPhoneNoScreen.id: (context) => LoginPhoneNoScreen(),
        AppHomePage.id: (context) => AppHomePage(),
        NewUserScreen.id: (context) => NewUserScreen(),
      },
    );
  }
}
