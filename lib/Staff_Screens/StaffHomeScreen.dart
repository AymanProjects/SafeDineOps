import 'dart:async';
import 'package:SafeDineOps/Admin_Screens/Home/widgets/SafeDineDrawer.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Notifications.dart';
import 'package:SafeDineOps/Staff_Screens/PendingOrdersScreen.dart';
import 'package:SafeDineOps/Staff_Screens/AcceptedOrdersScreen.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffHomeScreen extends StatefulWidget {
  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  StreamSubscription notificationStream;
  @override
  void dispose() async {
    notificationStream
        ?.cancel(); // stop the stream when the widget is destroyed
    print('stream cancelled');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Branch branch = Provider.of<Branch>(context, listen: false);
    bool firstNotification = true;
    notificationStream =
        Notifications.getBranchNotifications(branchID: branch.getID()).listen(
            (data) {
      if (!firstNotification && data != null) {
        print(data);
        SafeDineSnackBar.showNotification(
          type: SnackbarType.Warning,
          context: context,
          msg: data,
          duration: 100,
        );
      } else
        firstNotification = false;
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      hasDrawer: true,
      drawer: SafeDineDrawer(hasOrderHoistoryButton: true),
      title: 'Branch orders',
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BorderedButton(
                text: 'Pending orders',
                function: () {
                  pushToScreen(PendingOrdersScreen(), context);
                },
              ),
              SizedBox(height: 10),
              BorderedButton(
                text: 'Accepted orders',
                function: () {
                  pushToScreen(AcceptedOrdersScreen(), context);
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void pushToScreen(Widget screen, context) {
    Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);
    Branch branch = Provider.of<Branch>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            Provider<Restaurant>.value(
              value: restaurant,
            ),
            Provider<Branch>.value(
              value: branch,
            )
          ],
          child: screen,
        );
      }),
    );
  }
}
