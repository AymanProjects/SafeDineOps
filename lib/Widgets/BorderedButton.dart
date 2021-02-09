import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final String text;
  final Function function;
  BorderedButton({this.text = '', @required this.function});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: function,
      child: Text(text),
      color: Colors.transparent,
      minWidth: double.infinity,
      height: 40,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.black)),
    );
  }
}
