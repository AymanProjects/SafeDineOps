import 'package:flutter/material.dart';

class FadeRouteAnimation extends PageRouteBuilder {
  final Widget page;
  FadeRouteAnimation({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Align(
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
  );
}