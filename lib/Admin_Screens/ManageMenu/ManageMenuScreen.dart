import 'package:SafeDineOps/Admin_Screens/ManageMenu/widgets/CategoryDropDown.dart';
import 'package:SafeDineOps/Models/Category.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ManageMenuScreen extends StatefulWidget {
  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        Provider.of<Restaurant>(context, listen: false);
    return GlobalScaffold(
      hasDrawer: false,
      title: 'Manage Menu',
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ...restaurant.getMenu().map((category) {
                  return CategoryDropDown(category, () {
                    setState(() {});
                  });
                }).toList(),
                SizedBox(
                  height: 20,
                ),
                BorderedButton(
                  text: 'Add Category',
                  function: () {
                    SafeDineSnackBar.showTextFieldDialog(
                      isEmail: false,
                      initialData: '',
                      hint: 'Breakfast...',
                      icon: null,
                      context: context,
                      message: 'Enter category name',
                      positiveActionText:
                          Text('add', style: TextStyle(color: Colors.blue)),
                      negativeActionText: Text('cancel'),
                      positiveAction: (name, FlashController controller) async {
                        try {
                          restaurant.getMenu().add(Category(name: name));
                          await restaurant.updateOrCreate();
                          controller.dismiss();
                          setState(() {});
                        } on PlatformException catch (exception) {
                          SafeDineSnackBar.showNotification(
                            type: SnackbarType.Error,
                            context: context,
                            msg: FirebaseException.generateReadableMessage(
                                exception),
                          );
                        }
                      },
                      negativeAction: null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
