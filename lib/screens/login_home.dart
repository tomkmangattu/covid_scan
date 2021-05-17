import 'package:covid_scan/screens/phone_no.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';

class LoginHome extends StatelessWidget {
  static const String id = 'login home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/qr-app.png'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPhoneNoScreen.id);
                },
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: kLoginButtonDec,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
