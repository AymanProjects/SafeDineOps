import 'package:SafeDineOps/Models/ItemDetails.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderRecordsScreen extends StatelessWidget {
  final String branchID;
  OrderRecordsScreen({@required this.branchID});
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      hasDrawer: false,
      title: 'Order Records',
      body: showRecords(context),
    );
  }

  Widget showRecords(context) {
    return StreamBuilder<List<Order>>(
      stream: Database.getAllOrdersOfBranchWhere(branchID: branchID),
      builder: (_, AsyncSnapshot<List<Order>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.length > 0)
            return recordsList(snapshot.data);
          else
            return showEmptyRecords();
        } else {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget recordsList(List<Order> orders) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 15, bottom: 85),
        separatorBuilder: (context, _) => Container(
          height: 20,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return recordCard(
              context: context,
              index: orders.length - index,
              order: orders[index]);
        },
      ),
    );
  }

  Widget recordCard({context, int index, Order order}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 10),
          child: Text("${order.getReadableDate()}"),
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("#$index ${order.getStatus()}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                  Text(
                    "SAR ${order.getTotalPrice().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Provider.of<AppTheme>(context).grey,
                height: 30,
              ),
              Text(
                "Order Details:",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 210,
                child: Text(
                  getItemsName(order.getItemDetails()),
                  style: TextStyle(
                    fontSize: 15,
                    color: Provider.of<AppTheme>(context).grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getItemsName(List<ItemDetails> itemDetails) {
    String names = '';
    for (ItemDetails item in itemDetails) {
      names += ', ${item.getItem().getName()}';
    }
    if (names.length > 0) names = names.substring(2); // remove the first coma ,
    return names;
  }

  Widget showEmptyRecords() {
    return Expanded(
      child: Center(
        child: Text(
          'There are no order records',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
