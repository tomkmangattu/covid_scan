import 'package:covid_scan/screens/home_screens/generate_qr.dart';

import 'package:covid_scan/screens/home_screens/app_home.dart';
import 'package:covid_scan/screens/login_home.dart';
import 'package:covid_scan/screens/new_user.dart';
import 'package:covid_scan/screens/phone_no.dart';
import 'package:covid_scan/screens/home_screens/scan_qr.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:covid_scan/utilities/theme_changer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final bool dark = await getStoredTheme();
  runApp(MyApp(
    dark: dark,
  ));
}

class MyApp extends StatelessWidget {
  final bool dark;
  MyApp({@required this.dark});
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      defaultBrightness: dark ? Brightness.dark : Brightness.light,
      builder: (context, _brightness) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: _brightness,
            primaryColor: kAppPrimColor,
            // default font for app
            fontFamily: 'Lato',
          ),
          // check for persistant sign in
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
      },
    );
  }
}

Future<bool> getStoredTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool dark = prefs.getBool('dark');
  if (dark == null) {
    prefs.setBool('dark', false);
    return false;
  }
  print(dark.toString());
  return dark;
}
