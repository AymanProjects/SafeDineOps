import 'package:SafeDineOps/Admin_Screens/CreateQRScreen/widgets/QRImage.dart';
import 'package:SafeDineOps/Admin_Screens/CreateQRScreen/widgets/QRScreenDropDown.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateQRScreen extends StatelessWidget {
  final GlobalKey<QRImageState> _key = GlobalKey();
  Branch selectedBranch = Branch();
  String tableNumber = '';
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);

    return GlobalScaffold(
      hasDrawer: false,
      title: 'Create Qr Code for Table',
      body: Expanded(
        child: FutureBuilder<List<Branch>>(
          future: Database.getBranchesOfRestaurant(restaurant.getID()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.length < 1) {
                return showEmptyBranches();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      QRScreenDropDown(
                        branches: snapshot.data,
                        onChanged: (branch) {
                          selectedBranch = branch;
                          _key.currentState.updateQR(
                            content: {
                              'tableNumber': tableNumber,
                              'branchID': selectedBranch.getID(),
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      textField(),
                      SizedBox(height: 60),
                      QRImage(key: _key),
                      SizedBox(height: 60),
                      saveButton(),
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }

  Widget saveButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        return isDownloading
            ? CircularProgressIndicator(
                backgroundColor: Colors.black,
              )
            : BorderedButton(
                text: 'Save QR to Gallery',
                function: () async {
                  setState(() => isDownloading = true);
                  await _key.currentState.saveImage();
                  setState(() => isDownloading = false);
                },
              );
      },
    );
  }

  Widget textField() {
    return TextField(
      onChanged: (newTableNumber) {
        tableNumber = newTableNumber;
        _key.currentState.updateQR(
          content: {
            'tableNumber': tableNumber,
            'branchID': selectedBranch.getID(),
          },
        );
      },
      decoration: InputDecoration(
        hintText: "Enter table number...",
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget showEmptyBranches() {
    return Center(
      child: Text(
        'There are no branches',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
