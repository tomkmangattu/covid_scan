import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// app primary color
const Color kAppPrimColor = Color(0xff2979ff);

final BoxDecoration kLoginButtonDec = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
        blurRadius: 3,
        offset: Offset(3, 3),
        spreadRadius: 1,
        color: Colors.black26)
  ],
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff1d39b6), Color(0xff1de9b6)],
  ),
);

final InputDecoration formdecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Color(0xff1d39b6), width: 3),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: kAppPrimColor, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red, width: 3),
  ),
  suffixStyle: TextStyle(color: Colors.red),
);

//Color(0xff1de9b6)
//Color(0xff00e5ff)
//Color(0xff00b8d4)

enum VaccineStatus {
  none,
  one,
  two,
}

final Map<VaccineStatus, String> vaccineStatusText = {
  VaccineStatus.none: 'none',
  VaccineStatus.one: 'one',
  VaccineStatus.two: 'two',
};

final CollectionReference fireStoreRef = FirebaseFirestore.instance
    .collection('covin_scan')
    .doc(FirebaseAuth.instance.currentUser.uid)
    .collection(FirebaseAuth.instance.currentUser.uid);

final CollectionReference fireStoreShopRef = FirebaseFirestore.instance
    .collection('covin_scan')
    .doc(FirebaseAuth.instance.currentUser.uid)
    .collection(FirebaseAuth.instance.currentUser.uid)
    .doc('ShopRegistor')
    .collection('ShopRegistor');

final firebase_storage.Reference profilePicRef =
    firebase_storage.FirebaseStorage.instance.ref('profilePic');

final visitsdateFormator = DateFormat('dd-MM-yyyy');
final visitstimeFormator = DateFormat('jm');
