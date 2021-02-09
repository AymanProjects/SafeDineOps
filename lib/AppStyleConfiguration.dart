import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Utilities/AppTheme.dart';

class AppStyleConfiguration extends StatelessWidget {
  final Widget child;

  AppStyleConfiguration({@required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppTheme>(
      create: (_) => AppTheme(),
      builder: (context,_) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Provider.of<AppTheme>(context).currentTheme().brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (scroll) {
          scroll.disallowGlow();
          return true;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<AppTheme>(context).currentTheme(),
          home: ScreenUtilInit(
            child: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child,
              ),
            ),
          ),
        ),
    );
      },
    );
  }
}