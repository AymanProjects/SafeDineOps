import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color color;
  AppLogo({this.size, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/svg_images/SafeDine.svg',
        height: size,
        color: color,
      ),
    );
  }
}
