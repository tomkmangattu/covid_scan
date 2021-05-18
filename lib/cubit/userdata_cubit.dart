import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:covid_scan/models/UserData.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:meta/meta.dart';

part 'userdata_state.dart';

class UserdataCubit extends Cubit<UserdataState> {
  final User firebaseUser = FirebaseAuth.instance.currentUser;
  UserdataCubit() : super(UserdataInitial());

  void uploadData(
      {UserData userData, VaccineStatus vaccineStatus, File file}) async {
    emit(UserdataLoading());
    final String phoneNo = firebaseUser.phoneNumber;
    final Map<String, dynamic> data = {
      'userName': userData.name,
      'phoneNo': phoneNo,
      'emailId': userData.emailId ?? '',
      'pinCode': userData.pinCode ?? '',
      'age': userData.age,
      'vaccineStatus': vaccineStatusText[vaccineStatus],
    };
    try {
      // upload user data
      await fireStoreRef
          .doc('userInfo')
          .collection('userInfo')
          .add(data)
          .onError((error, _) {
        emit(UserdataError(error: 'Error Uploading userData'));
        return;
      }).then((_) {
        print('user data uploaded');
      });

      // upload profile picture
      if (file != null) {
        firebase_storage.Reference pic = profilePicRef.child(firebaseUser.uid);
        await pic.putFile(file).onError((error, _) {
          emit(UserdataSucess(
              message: 'Sorry Profile picture uploading failed'));
          return;
        }).then((_) {
          print('pic uploaded');
        });
      }
      firebaseUser.updateProfile(displayName: userData.name);
    } on FirebaseException catch (_) {
      emit(UserdataError(error: 'Unknown Error'));
    }

    emit(UserdataSucess(message: ''));
  }
}
