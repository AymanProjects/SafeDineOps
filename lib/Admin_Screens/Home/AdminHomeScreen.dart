import 'package:SafeDineOps/Admin_Screens/CreateQRScreen/CreateQRScreen.dart';
import 'package:SafeDineOps/Admin_Screens/Home/widgets/SafeDineDrawer.dart';
import 'package:SafeDineOps/Admin_Screens/ManageBranch/ManageBranchScreen.dart';
import 'package:SafeDineOps/Admin_Screens/ManageMenu/ManageMenuScreen.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GlobalScaffold(
        title: 'Welcome',
        hasDrawer: true,
        drawer: SafeDineDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              BorderedButton(
                text: 'Manage menu',
                function: () => pushToScreen(ManageMenuScreen(), context),
              ),
              SizedBox(height: 15),
              BorderedButton(
                text: 'Manage branches',
                function: () => pushToScreen(ManageBranchScreen(), context),
              ),
              SizedBox(height: 15),
              BorderedButton(
                text: 'Create QR for table',
                function: () => pushToScreen(CreateQRScreen(), context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushToScreen(Widget screen, context) {
    Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Provider<Restaurant>.value(
          value: restaurant,
          child: screen,
        ),
      ),
    );
  }
}
