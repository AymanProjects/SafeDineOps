import 'package:SafeDineOps/Admin_Screens/ManageBranch/widgets/BranchTile.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ManageBranchScreen extends StatefulWidget {
  @override
  _ManageBranchScreenState createState() => _ManageBranchScreenState();
}

class _ManageBranchScreenState extends State<ManageBranchScreen> {
  List<Branch> branches = [];

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  fetchBranches() async {
    branches = await Database.getBranchesOfRestaurant(
        Provider.of<Restaurant>(context, listen: false).getID());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        Provider.of<Restaurant>(context, listen: false);
    return GlobalScaffold(
      hasDrawer: false,
      title: 'Manage Branches',
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ...branches?.map((branch) {
                  return BranchTile(
                    branch: branch,
                    onDelete: () {
                      branches.remove(branch);
                      setState(() {});
                    },
                  );
                })?.toList(),
                SizedBox(
                  height: 20,
                ),
                BorderedButton(
                  text: 'Add Branch',
                  function: () {
                    SafeDineSnackBar.showTextFieldDialog(
                      isEmail: false,
                      initialData: '',
                      hint: 'Branch name...',
                      icon: null,
                      context: context,
                      message: 'Enter branch name',
                      positiveActionText:
                          Text('add', style: TextStyle(color: Colors.blue)),
                      negativeActionText: Text('cancel'),
                      positiveAction: (name, FlashController controller) async {
                        try {
                          Branch newBranch = Branch(
                              name: name, restaurantID: restaurant.getID());
                          await newBranch.updateOrCreate();
                          branches.add(newBranch);
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
