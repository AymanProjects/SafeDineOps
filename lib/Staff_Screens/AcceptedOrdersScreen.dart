import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Staff_Screens/widgets/OrderCard.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptedOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Branch branch = Provider.of<Branch>(context, listen: false);
    return GlobalScaffold(
      title: 'Accepted orders',
      hasDrawer: false,
      body: getBranchOrders(branch: branch),
    );
  }

  Widget getBranchOrders({Branch branch}) {
    return StreamBuilder<List<Order>>(
      stream: Database.getAllOrdersOfBranchWhere(
          branchID: branch.getID(), status: ['BeingPrepared']),
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
            isSummarized: true,
            order: activeOrders[index],
            positiveAction: () async {
              activeOrders[index].setStatus(OrderStatus.Served.toString());
              await activeOrders[index].updateOrCreate();
            },
            positiveActionText: 'Done!',
            negativeAction: null,
            negativeActionText: '',
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
}
