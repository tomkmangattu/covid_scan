import 'package:covid_scan/screens/phone_login.dart';
import 'package:flutter/material.dart';

class LoginPhoneNoScreen extends StatefulWidget {
  static const String id = 'Login phone number screeen';
  @override
  _LoginPhoneNoScreenState createState() => _LoginPhoneNoScreenState();
}

class _LoginPhoneNoScreenState extends State<LoginPhoneNoScreen> {
  String _phoneNo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const String _pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(_pattern);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Just a few steps to go..',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style:
                      TextStyle(letterSpacing: 2, fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  validator: _validator,
                  onChanged: (String value) {
                    _phoneNo = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your 10 digit mobile number',
                    prefixText: '+91 ',
                    prefixIcon: Icon(Icons.phone),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff1976d2), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios_rounded),
        onPressed: _onPreceesdButtonPressed,
      ),
    );
  }

  String _validator(String value) {
    if (value.length != 10)
      return 'Phone number should be of 10 digits';
    else if (!regExp.hasMatch(value))
      return 'Please enter a valid mobile number';
    return null;
  }

  void _onPreceesdButtonPressed() {
    if (_formKey.currentState.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhLoginScreen(
            phoneNo: _phoneNo,
          ),
        ),
      );
    }
  }
}
