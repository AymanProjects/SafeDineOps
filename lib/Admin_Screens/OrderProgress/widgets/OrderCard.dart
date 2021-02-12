import 'package:SafeDineOps/Models/ItemDetails.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final int index;
  OrderCard({this.index, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text("Being prepared",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
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
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 210,
            child: Text(
              getItemsNames(order.getItemDetails()),
              style: TextStyle(
                fontSize: 14,
                color: Provider.of<AppTheme>(context).grey,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              order.getPaymentType() == 'cash'
                  ? InkWell(
                      child:
                          Text('cancel', style: TextStyle(color: Colors.red)),
                      onTap: () {
                        showConfirmationDialog(context, order);
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  showConfirmationDialog(context, order) {
    SafeDineSnackBar.showConfirmationDialog(
      message: 'Do you really want to cancel this order? \n',
      context: context,
      positiveActionText: Text(
        'Yes',
        style: TextStyle(color: Colors.red, fontSize: 14),
      ),
      positiveAction: () async {
        try {
      //    Visitor visitor = Provider.of<Visitor>(context, listen: false);
      //    await visitor.cancelOrder(order);
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
      negativeAction: null,
    );
  }

  String getItemsNames(List<ItemDetails> itemDetails) {
    String names = '';
    for (ItemDetails item in itemDetails) {
      names += ', ${item.getItem().getName()}';
    }
    if (names.length > 0) names = names.substring(2); // remove the first coma ,
    return names;
  }
}
