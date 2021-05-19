import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  static const String id = 'qr code scanner';
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  bool read = false;
  QRViewController _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final DateFormat formator = DateFormat('dd-MM-yyyy');
  final _now = DateTime.now();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController.pauseCamera();
    }
    _qrViewController.resumeCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _qrViewController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                  _qrViewController == null
                      ? Text('Reading Qr Code')
                      : Text('Uploading to Cloud'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _qrViewController = controller;
      });
      if (scanData != null) {
        controller.pauseCamera();
        // controller.dispose();
        _uploadtoDataBase(scanData.code);
      }
    });
  }

  void _uploadtoDataBase(String result) async {
    // adding to shop registor
    if (result.contains('covin_scan_u/ ')) {
      final List scandata = result.split('/ ');
      final shopId = scandata.last;
      final shopName = scandata[1];
      // print(shopId);
      final String now = formator.format(DateTime.now());
      final _userId = FirebaseAuth.instance.currentUser.uid;
      final name = FirebaseAuth.instance.currentUser.displayName;
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('covin_scan')
          .doc(shopId)
          .collection(shopId)
          .doc('ShopRegistor')
          .collection('ShopRegistor')
          .doc(now)
          .collection(now);
      Map<String, dynamic> data = {
        'userId': _userId,
        'DateTime': _now,
        'custName': name,
      };

      // adding to customer registor
      Map<String, dynamic> userData = {
        'shopId': shopId,
        'shopName': shopName,
        'DateTime': _now,
      };

      final CollectionReference reference =
          fireStoreRef.doc('custRegistor').collection('custRegistor');
      try {
        await collectionReference.add(data);
        await reference.add(userData);
        print('uploaded to registor');
      } on FirebaseException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Occured while uploading data')));
      }
      Navigator.pop(context);
    }
  }
}
