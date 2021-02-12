import 'package:SafeDineOps/Admin_Screens/Home/widgets/SafeDineDrawer.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Staff_Screens/widgets/OrderCard.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CashierHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Branch branch = Provider.of<Branch>(context, listen: false);
    return GlobalScaffold(
      title: '${branch.getName()}, Cashier',
      hasDrawer: true,
      drawer: SafeDineDrawer(),
      body: getBranchOrders(branch: branch),
    );
  }

  Widget getBranchOrders({Branch branch}) {
    return StreamBuilder<List<Order>>(
      stream: Database.getAllOrdersOfBranch(branchID: branch.getID(), status: 'New'),
      builder: (_, AsyncSnapshot<List<Order>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0)
            return showActiveOrders(snapshot.data);
          else
            return showNoOrders();
        } else {
          return Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget showActiveOrders(List<Order> activeOrders) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(15),
        separatorBuilder: (context, _) => Container(
          height: 20,
        ),
        itemCount: activeOrders.length,
        itemBuilder: (context, index) {
          return OrderCard(
            order: activeOrders[index],
            positiveActionText: 'Accept',
            positiveAction: () async {
              print('test');
              activeOrders[index].setStatus(OrderStatus.BeingPrepared.toString());
              await activeOrders[index].updateOrCreate();
            },
            negativeActionText: 'Reject',
            negativeAction: () {
              showConfirmationDialog(context: context,order: activeOrders[index]);
            },
          );
        },
      ),
    );
  }

  Widget showNoOrders() {
    return Expanded(
      child: Center(
        child: Text(
          'There are no active orders.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  showConfirmationDialog({context, Order order}) {
    SafeDineSnackBar.showConfirmationDialog(
      message: 'Do you really want to reject this order? \n',
      context: context,
      positiveActionText: Text(
        'Yes',
        style: TextStyle(color: Colors.red, fontSize: 14),
      ),
      positiveAction: () async {
        try {
          order.setStatus(OrderStatus.Cancelled.toString());
          await order.updateOrCreate();
        } on PlatformException catch (exception) {
          String msg = FirebaseException.generateReadableMessage(exception);
          SafeDineSnackBar.showNotification(
            type: SnackbarType.Error,
            context: context,
            msg: msg,
          );
        }
      },
      negativeActionText: Text(
        'No',
        style: TextStyle(fontSize: 14),
      ),
      negativeAction: () {
        // no code needed
      },
    );
  }
}
