import 'dart:io';
import 'dart:typed_data';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dio/dio.dart';

class QRImage extends StatefulWidget {
  QRImage({Key key}) : super(key: key);

  @override
  QRImageState createState() => QRImageState();
}

class QRImageState extends State<QRImage> {
  Map content = {};

  void updateQR({Map content}) {
    setState(() {
      this.content = content;
    });
  }

  Future<void> saveImage() async {
    if (await Permission.storage.request().isGranted) {
      Response response = await Dio().get(
        "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=$content",
        options: Options(responseType: ResponseType.bytes),
      );
      await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
      );
      SafeDineSnackBar.showNotification(
          type: SnackbarType.Success,
          context: context,
          msg: 'Image Downloaded to Gallery');
    } else if (await Permission.storage.isPermanentlyDenied) {
      SafeDineSnackBar.showConfirmationDialog(
        context: context,
        message: 'Please allow storage access',
        positiveActionText: Text('allow', style: TextStyle(color: Colors.blue)),
        negativeActionText: Text('cancel'),
        positiveAction: () => openAppSettings(),
        negativeAction: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: '$content',
      size: 200,
    );
  }
}
