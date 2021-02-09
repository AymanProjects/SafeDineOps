import 'package:SafeDineOps/Admin_Screens/ManageMenu/AddItemScreen.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Category.dart';
import 'package:SafeDineOps/Models/FoodItem.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BranchTile extends StatefulWidget {
  final Branch branch;
  final Function onDelete;
  BranchTile({this.branch, this.onDelete});

  @override
  _BranchTileState createState() => _BranchTileState();
}

class _BranchTileState extends State<BranchTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: _actionButtons(context),
    );
  }

  Widget _actionButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.branch.getName()),
        Spacer(),
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
              initialData: widget.branch.getName(),
              message: 'Edit branch name',
              positiveActionText:
                  Text('update', style: TextStyle(color: Colors.blue)),
              negativeActionText: Text('cancel'),
              positiveAction: (newName, FlashController controller) async {
                try {
                  widget.branch.setName(newName);
                  await widget.branch.updateOrCreate();
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
        SizedBox(width: 15),
        InkWell(
          child: Icon(
            Icons.clear,
            size: 20,
          ),
          onTap: () {
            SafeDineSnackBar.showConfirmationDialog(
              context: context,
              message: 'Delete this branch?',
              positiveActionText:
                  Text('delete', style: TextStyle(color: Colors.red)),
              negativeActionText: Text('cancel'),
              positiveAction: () async {
                try {
                  await Database.deleteDocument(
                      widget.branch.getID(), Database.branchesCollection);
                  widget.onDelete();
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
