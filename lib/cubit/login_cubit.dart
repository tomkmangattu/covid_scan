import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  String verificationId;
  String phno;
  bool signStarted = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  LoginCubit() : super(LoginInitial());

  void requestOtp({String phoneNo}) async {
    phno = '+91' + phoneNo;

    Future<void> _signInwithCredential(PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential).onError((error, _) {
        emit(LoginFail(reason: 'Sorry Otp Verification failed'));
        return;
      }).then((_) {
        emit(LoginSucess());
        return;
      });
    }

    Future<void> _gotoOtpScreen() async {
      await Future.delayed(Duration(seconds: 6));
      if (!signStarted) emit(LoginOtp());
    }

    final PhoneVerificationCompleted _verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) {
      signStarted = true;
      print('ath completed');
      _signInwithCredential(phoneAuthCredential);
    };

    final PhoneVerificationFailed _verificationFailed =
        (FirebaseAuthException expection) {
      emit(LoginFail(reason: 'Sorry Phone number verification failed'));
    };

    final PhoneCodeSent _codeSent = (String id, int resentToken) {
      verificationId = id;
      print('code sent');
      _gotoOtpScreen();
    };

    final PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout =
        (String verificationId) {
      print('Auto retrival time out ');
      emit(LoginFail(reason: 'Sorry time Out'));
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phno,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> signInWithPhoneNo(String otp) async {
    emit(LoginLoading());
    UserCredential userCredential;
    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      userCredential = await auth.signInWithCredential(authCredential);
    } on FirebaseException catch (_) {
      emit(LoginFail(reason: 'Sorry error occured while verifying Otp'));
      return;
    }
    if (userCredential != null) {
      emit(LoginSucess());
    }
  }

  Future<void> checkForNewUser() async {
    await Future.delayed(Duration(seconds: 2));
    final userName = FirebaseAuth.instance.currentUser.displayName;
    if (userName == null) {
      emit(NewUser());
    } else {
      emit(OldUser());
    }
  }
}
