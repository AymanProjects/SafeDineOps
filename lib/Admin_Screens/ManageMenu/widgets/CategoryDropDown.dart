import 'package:SafeDineOps/Admin_Screens/ManageMenu/AddItemScreen.dart';
import 'package:SafeDineOps/Models/Category.dart';
import 'package:SafeDineOps/Models/FoodItem.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CategoryDropDown extends StatefulWidget {
  final Category category;
  final Function updateParent;
  CategoryDropDown(this.category, this.updateParent);

  @override
  _CategoryDropDownState createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      title: Text(widget.category.getName()),
      subtitle: _actionButtons(context),
      children: widget.category
          .getItems()
          .map((foodItem) => _item(foodItem))
          .toList(),
    );
  }

  Widget _actionButtons(context) {
    Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);
    return Row(
      children: [
        InkWell(
          child: Icon(
            Icons.add,
            size: 21,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider<Restaurant>.value(
                        value: restaurant,
                        child: AddItemScreen(
                            widget.category, widget.updateParent))));
          },
        ),
        SizedBox(width: 10),
        InkWell(
          child: Icon(
            Icons.edit_outlined,
            size: 20,
          ),
          onTap: () {
            SafeDineSnackBar.showTextFieldDialog(
              isEmail: false,
              context: context,
              hint: '',
              icon: null,
              initialData: widget.category.getName(),
              message: 'Edit category name',
              positiveActionText:
                  Text('update', style: TextStyle(color: Colors.blue)),
              negativeActionText: Text('cancel'),
              positiveAction: (newName, FlashController controller) async {
                try {
                  widget.category.setName(newName);
                  await restaurant.updateOrCreate();
                  controller.dismiss();
                  setState(() {});
                } on PlatformException catch (exception) {
                  SafeDineSnackBar.showNotification(
                    type: SnackbarType.Error,
                    context: context,
                    msg: FirebaseException.generateReadableMessage(exception),
                  );
                }
              },
              negativeAction: null,
            );
          },
        ),
        SizedBox(
          width: 15,
        ),
        InkWell(
          child: Icon(
            Icons.clear,
            size: 20,
          ),
          onTap: () {
            SafeDineSnackBar.showConfirmationDialog(
              context: context,
              message: 'Delete this category?',
              positiveActionText:
                  Text('delete', style: TextStyle(color: Colors.red)),
              negativeActionText: Text('cancel'),
              positiveAction: () async {
                try {
                  restaurant.getMenu().remove(widget.category);
                  await restaurant.updateOrCreate();
                  widget.updateParent();
                  setState(() {});
                } on PlatformException catch (exception) {
                  SafeDineSnackBar.showNotification(
                    type: SnackbarType.Error,
                    context: context,
                    msg: FirebaseException.generateReadableMessage(exception),
                  );
                }
              },
              negativeAction: null,
            );
          },
        ),
      ],
    );
  }

  Widget _item(FoodItem item) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.getName()),
          Text(item.getPrice().toStringAsFixed(2)),
        ],
      ),
    );
  }
}
