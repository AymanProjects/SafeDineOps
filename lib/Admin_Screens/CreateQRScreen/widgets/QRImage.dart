import 'dart:typed_data';
import 'package:SafeDineOps/Models/Restaurant.dart';
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
      try {
        List<int> image = await Restaurant().createTableQR(content);
        await ImageGallerySaver.saveImage(
          Uint8List.fromList(image),
          quality: 100,
        );
        SafeDineSnackBar.showNotification(
            type: SnackbarType.Success,
            context: context,
            msg: 'Image Downloaded to Gallery');
        Navigator.pop(context);
      } on DioError catch (exception) {
        SafeDineSnackBar.showNotification(
          type: SnackbarType.Error,
          context: context,
          msg: 'Network error',
        );
      }
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
