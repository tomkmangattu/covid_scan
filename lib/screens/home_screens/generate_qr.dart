import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:covid_scan/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart' show Share;

class QrGeneratorPage extends StatelessWidget {
  static const String id = 'qr gernarator page';
  final String qrCode;
  final GlobalKey _globalKey = GlobalKey();

  QrGeneratorPage({this.qrCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareQrCode(context, true);
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              _shareQrCode(context, false);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Covid Scan',
                        style: TextStyle(
                          fontSize: 26,
                          color: kAppPrimColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    QrImage(
                      data: qrCode,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Scan the Qr code using covid_scan app',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _shareQrCode(BuildContext context, bool share) async {
    try {
      // convert qr code to image
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      if (!share) {
        // save to permanent directory

        final permenentDir = await getExternalStorageDirectory();
        final File permentFile =
            await File('${permenentDir.path}/qrcodeImage.png').create();
        debugPrint(permentFile.path);
        await permentFile.writeAsBytes(pngBytes);
        _showSnack(context, permentFile.path);
      }
      // share file
      else {
        // save image
        final tempDir = await getTemporaryDirectory();
        final File file =
            await File('${tempDir.path}/qrcodeImage.png').create();
        await file.writeAsBytes(pngBytes);

        // sent qr code to other apps
        Share.shareFiles(['${tempDir.path}/qrcodeImage.png'], text: 'Qr Code');
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sorry something went wrong')));
    }
  }

  void _showSnack(BuildContext context, String location) {
    final List<String> paths = location.split('/');
    List<String> reducedPath = [];
    for (var p in paths) {
      if (p == '' || p == 'storage' || p == 'emulated' || p == '0') {
      } else {
        reducedPath.add('/' + p);
      }
    }
    print(paths);
    String path;

    if (paths[3] == '0') {
      path = 'Internal Storage' + reducedPath.join();
    } else {
      path = 'Sd Card' + reducedPath.join();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Image saved to : ' + path),
          duration: Duration(seconds: 6),
          backgroundColor: kAppPrimColor),
    );
  }
}
