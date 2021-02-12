import 'package:SafeDineOps/Models/ItemDetails.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  String positiveActionText;
  String negativeActionText;
  Function positiveAction;
  Function negativeAction;
  final Order order;
  OrderCard({this.order, this.positiveAction, this.negativeAction, this.positiveActionText, this.negativeActionText});
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
              Text("Table Number ${order.getTableNumber()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  )),
              Spacer(),
              Text(
                "SAR ${order.getTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              FaIcon(
                  order.getPaymentType() == 'cash'
                      ? FontAwesomeIcons.moneyBillWave
                      : FontAwesomeIcons.paypal,
                  size: 15,
                  color: order.getPaymentType() == 'cash'
                      ? Colors.green
                      : Colors.blue),
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
                          Text(negativeActionText, style: TextStyle(color: Colors.red)),
                      onTap: () {
                        // showConfirmationDialog(context, order);
                        negativeAction();
                      },
                    )
                  : SizedBox(),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child:
                    Text(positiveActionText, style: TextStyle(color: Colors.green[800])),
                onTap: () async {
                  // order.setStatus(OrderStatus.Served.toString());
                  // await order.updateOrCreate();
                  positiveAction();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  // showConfirmationDialog(context, order) {
  //   SafeDineSnackBar.showConfirmationDialog(
  //     message: 'Do you really want to cancel this order? \n',
  //     context: context,
  //     positiveActionText: Text(
  //       'Yes',
  //       style: TextStyle(color: Colors.red, fontSize: 14),
  //     ),
  //     positiveAction: () async {
  //       try {
  //         order.setStatus(OrderStatus.Cancelled.toString());
  //         await order.updateOrCreate();
  //       } on PlatformException catch (exception) {
  //         String msg = FirebaseException.generateReadableMessage(exception);
  //         SafeDineSnackBar.showNotification(
  //           type: SnackbarType.Error,
  //           context: context,
  //           msg: msg,
  //         );
  //       }
  //     },
  //     negativeActionText: Text(
  //       'No',
  //       style: TextStyle(fontSize: 14),
  //     ),
  //     negativeAction: () {
  //       // no code needed
  //       _showMyDialog(context, order);
  //     },
  //   );
  // }

  String getItemsNames(List<ItemDetails> itemDetails) {
    String names = '';
    for (ItemDetails item in itemDetails) {
      names += ', ${item.getItem().getName()}';
    }
    if (names.length > 0) names = names.substring(2); // remove the first coma ,
    return names;
  }


  Future<void> _showMyDialog(context, Order order) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
