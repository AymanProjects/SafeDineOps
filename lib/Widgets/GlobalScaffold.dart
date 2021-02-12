import 'package:SafeDineOps/Admin_Screens/Home/widgets/DrawerIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget actionButtton;
  final bool hasDrawer; // if true == (SideBarIcon), if false ==(Back Icon)
  final Widget drawer;

  GlobalScaffold(
      {@required this.body,
      @required this.title,
      this.actionButtton,
      @required this.hasDrawer,
      this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Colors.black12,
        drawerEdgeDragWidth: 30,
        drawer: drawer,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 15.w,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Builder(
            builder: (context) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      hasDrawer
                          ? Scaffold.of(context).openDrawer()
                          : Navigator.of(context).pop();
                    },
                    child: hasDrawer
                        ? DrawerIcon(
                            width: 22.w,
                            hieght: 2.w,
                            spaceBetween: 4.w,
                            color: Colors.black54,
                          )
                        : Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: Colors.black54,
                          )),
                actionButtton == null ? SizedBox() : actionButtton,
              ],
            ),
          ),
        ),
        body: Column(
          children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: 50,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          body,
        ]));
  }
}
