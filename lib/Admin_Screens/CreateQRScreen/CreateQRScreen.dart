import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';

class CreateQRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      hasDrawer: false,
      title: 'Create Qr Code for Table',
      body: Text('QR Generator'),
    );
  }
}
