import 'package:covid_scan/cubit/signout_cubit.dart';
import 'package:covid_scan/screens/login_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  final _username = FirebaseAuth.instance.currentUser.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ' + _username),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(' Sign Out'),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  BuildContext ctk =
                      BlocProvider.of<SignoutCubit>(context).context;
                  if (Navigator.canPop(ctk)) Navigator.pop(ctk);
                  Navigator.popAndPushNamed(ctk, LoginHome.id);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
