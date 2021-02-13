import 'package:SafeDineOps/Models/AddOn.dart';
import 'package:SafeDineOps/Models/ItemDetails.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderCard extends StatelessWidget {
  final String positiveActionText;
  final String negativeActionText;
  final Function positiveAction;
  final Function negativeAction;
  final bool isSummarized;
  final Order order;
  OrderCard(
      {@required this.order,
      this.isSummarized = false,
      @required this.positiveAction,
      @required this.negativeAction,
      this.positiveActionText = '',
      this.negativeActionText = ''});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
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
            color: Colors.grey,
            height: 30,
          ),
          SizedBox(
            height: 5,
          ),
          isSummarized ? summarizedDetails() : detailedDetails(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              negativeAction != null
                  ? InkWell(
                      child: Text(negativeActionText,
                          style: TextStyle(color: Colors.red)),
                      onTap: () {
                        negativeAction();
                      },
                    )
                  : SizedBox(),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Text(positiveActionText,
                    style: TextStyle(color: Colors.green[800])),
                onTap: () async {
                  positiveAction();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget summarizedDetails() {
    return Container(
      width: 210,
      child: Text(
        getItemsNamesAndQuantity(order.getItemDetails()),
      ),
    );
  }

  Widget detailedDetails() {
    return Container(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: order.getItemDetails().length,
              itemBuilder: (context, index) {
                ItemDetails itemDetails = order.getItemDetails()[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${itemDetails.getQuantity()}x ${itemDetails.getItem().getName()}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    itemDetails.getSelectedAddOns().length > 1
                        ? Text(
                            getAddonsNames(itemDetails.getSelectedAddOns()),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          Text(
            'Notes',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.blue[700]),
          ),
          SizedBox(height: 2),
          Text(
            order.getNote().isEmpty ? 'No notes' : order.getNote(),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String getAddonsNames(List<AddOn> addons) {
    String names = '';
    for (AddOn addon in addons) {
      names += ', ${addon.getName()}';
    }
    if (names.length > 0) names = names.substring(2); // remove the first coma ,
    return names;
  }

  String getItemsNamesAndQuantity(List<ItemDetails> itemDetails) {
    String names = '';
    for (ItemDetails item in itemDetails) {
      names += '${item.getQuantity()}x ${item.getItem().getName()}\n';
    }
    return names;
  }
}
