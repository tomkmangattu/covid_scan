import 'package:covid_scan/cubit/userdata_cubit.dart';
import 'package:covid_scan/models/user_form.dart';
import 'package:covid_scan/screens/home_screens/app_home.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewUserScreen extends StatefulWidget {
  static const String id = 'new user screen';

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  void _sucess(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.popAndPushNamed(context, AppHomePage.id);
  }

  void _error(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserdataCubit>(
      create: (BuildContext ctk) => UserdataCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('One more step to go..'),
          elevation: 0,
        ),
        body: BlocConsumer<UserdataCubit, UserdataState>(
          listener: (context, state) {
            if (state is UserdataSucess) {
              _sucess(context);
            }
            if (state is UserdataError) {
              _error(context);
            }
          },
          builder: (context, state) {
            if (state is UserdataLoading) return _loadingAnim();
            if (state is UserdataSucess) {
              return _result(true, state.message);
            }
            if (state is UserdataError) {
              return _result(false, state.error);
            }
            return UserForm();
          },
        ),
      ),
    );
  }

  Container _loadingAnim() {
    return Container(
      color: kAppPrimColor,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }

  Container _result(bool sucess, String message) {
    return Container(
        color: kAppPrimColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              sucess ? Icons.cloud_done_outlined : Icons.error_outlined,
              color: Colors.white,
              size: 200,
            ),
            Text(
              sucess
                  ? 'Data Uploaded sucessfully. ' + message
                  : 'Sorry, ' + message,
              style: TextStyle(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
