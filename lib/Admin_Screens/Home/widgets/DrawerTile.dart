import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  DrawerTile({@required this.icon, this.onTap, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 17),
      color: Colors.transparent,
      highlightColor: Colors.black.withOpacity(0.1),
      onPressed: () {
        if (onTap != null) onTap();
      },
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
