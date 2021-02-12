import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Staff_Screens/CashierHomeScreen.dart';
import 'package:SafeDineOps/Staff_Screens/StaffHomeScreen.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      hasDrawer: false,
      title: 'Staff or Cashier',
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BorderedButton(
                text: 'Staff',
                function: () {
                  pushToScreen(StaffHomeScreen(), context);
                },
              ),
              BorderedButton(
                text: 'Cashier',
                function: () {
                  pushToScreen(CashierHomeScreen(), context);
                },
              ),
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
      MaterialPageRoute(
        builder: (context)  {
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
        }
      ),
    );
  }
}
