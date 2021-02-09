import 'package:flutter/material.dart';

class DrawerIcon extends StatelessWidget {
  final double width;
  final double hieght;
  final double spaceBetween;
  final Color color;
  final double topPadding;
  final double leftPadding;

  DrawerIcon({this.hieght, this.spaceBetween, this.width, this.color, this.leftPadding=0, this.topPadding=0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: hieght,
            margin: EdgeInsets.only(bottom: spaceBetween),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(30)),
          ),
          Container(
            width: width - (width * 0.4),
            height: hieght,
            margin: EdgeInsets.only(bottom: spaceBetween),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(30)),
          ),
          Container(
            width: width,
            height: hieght,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(30)),
          ),
        ],
      ),
    );
  }
}