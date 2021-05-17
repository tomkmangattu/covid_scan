import 'package:covid_scan/cubit/userdata_cubit.dart';
import 'package:covid_scan/models/user_form.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewUserScreen extends StatefulWidget {
  static const String id = 'new user screen';

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
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
          listener: (context, state) {},
          builder: (context, state) {
            if (state is UserdataLoading) return _loadingAnim();
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
}
