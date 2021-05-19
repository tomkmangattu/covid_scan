import 'package:covid_scan/cubit/login_cubit.dart';
import 'package:covid_scan/screens/home_screens/app_home.dart';
import 'package:covid_scan/screens/login_home.dart';
import 'package:covid_scan/screens/new_user.dart';
import 'package:covid_scan/screens/otp_box.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhLoginScreen extends StatelessWidget {
  final String phoneNo;
  PhLoginScreen({this.phoneNo});

  void _loginFailed(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context);
  }

  void _oldCustomer(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppHomePage.id, ModalRoute.withName(LoginHome.id));
  }

  void _newUser(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, NewUserScreen.id, ModalRoute.withName(LoginHome.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFail) {
              _loginFailed(context);
            }
            if (state is LoginSucess) {
              context.read<LoginCubit>().checkForNewUser();
            }
            if (state is NewUser) {
              _newUser(context);
            }
            if (state is OldUser) {
              _oldCustomer(context);
            }
          },
          builder: (context, state) {
            if (state is LoginInitial) {
              context.read<LoginCubit>().requestOtp(phoneNo: phoneNo);
              return _loadingAnim();
            }
            if (state is LoginOtp) {
              return OtpBox();
            }
            if (state is LoginSucess) {
              return _result(sucess: true);
            }
            if (state is LoginFail) {
              return _result(sucess: false, code: state.reason);
            }
            return _loadingAnim();
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

  Container _result({@required bool sucess, String code}) {
    return Container(
      color: kAppPrimColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            sucess ? Icons.verified_user_outlined : Icons.error_outlined,
            color: Colors.white,
            size: 100,
          ),
          Text(
            sucess ? 'Login Sucess' : code + '. Please try after some time',
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
