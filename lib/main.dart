import 'package:SafeDineOps/Admin_Screens/Authentication/AuthScreen.dart';
import 'package:SafeDineOps/Admin_Screens/Home/AdminHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'AppStyleConfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await precachePicture(
    ExactAssetPicture(
      SvgPicture.svgStringDecoder,
      'assets/svg_images/SafeDine.svg',
    ),
    null,
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppStyleConfiguration(
      child: AuthScreen(),
    );
  }
}
