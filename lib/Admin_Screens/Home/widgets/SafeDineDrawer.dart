import 'dart:ui';
import 'package:SafeDineOps/Admin_Screens/OrderRecords/OrderRecordsScreen.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Admin_Screens/Home/widgets/DrawerTile.dart';
import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Widgets/AppLogo.dart';
import 'package:SafeDineOps/Widgets/SafeDineButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafeDineDrawer extends StatelessWidget {
  final bool hasOrderHoistoryButton;
  SafeDineDrawer({this.hasOrderHoistoryButton = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Stack(children: [
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 19.0,
              sigmaY: 19.0,
            ),
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 55.h),
                AppLogo(
                  size: 90.h,
                  color: Provider.of<AppTheme>(context, listen: false).primary,
                ),
                SizedBox(
                  height: 30.h,
                ),
                hasOrderHoistoryButton
                    ? DrawerTile(
                        text: 'Order history',
                        icon: CupertinoIcons.time,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderRecordsScreen()),
                          );
                        },
                      )
                    : SizedBox(),
              ],
            ),
            Column(
              children: [
                logoutButton(context),
                SizedBox(
                  height: 10.h,
                ),
                Text('Version 1.0.0'),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  Widget logoutButton(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SafeDineButton(
        color: Colors.redAccent,
        fontSize: 14.sp,
        text: 'Logout',
        function: () async {
          await Provider.of<Restaurant>(context, listen: false).logout();
          // pop to first rout in stack
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}
