import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart' show Share;

class QrGeneratorPage extends StatelessWidget {
  static const String id = 'qr gernarator page';
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareQrCode,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: RepaintBoundary(
              key: _globalKey,
              child: Column(
                children: [
                  QrImage(
                    data: 'tom k mangattu',
                    version: QrVersions.auto,
                    size: _size.width,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _shareQrCode() async {
    try {
      // convert qr code to image
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // save image
      final tempDir = await getTemporaryDirectory();
      final File file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      // sent qr code to other apps
      Share.shareFiles(['${tempDir.path}/image.png'], text: 'Qr Code');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
