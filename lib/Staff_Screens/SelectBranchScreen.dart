import 'package:SafeDineOps/Admin_Screens/Home/widgets/SafeDineDrawer.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Staff_Screens/StaffHomeScreen.dart';
import 'package:SafeDineOps/Staff_Screens/StaffSelectScreen.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectBranchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Restaurant res = Provider.of<Restaurant>(context, listen: false);
    return GlobalScaffold(
      title: 'Select branch to enter',
      hasDrawer: true,
      drawer: SafeDineDrawer(),
      body: FutureBuilder<List<Branch>>(
        future: Database.getBranchesOfRestaurant(res.getID()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data.length < 1) {
              return showEmptyBranches();
            }

            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...snapshot.data.map((branch) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Card(
                          child: ListTile(
                            title: Text(branch.getName() + ' - Branch'),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                      providers: [
                                        Provider<Branch>.value(
                                          value: branch,
                                        ),
                                        Provider<Restaurant>.value(
                                          value: res,
                                        ),
                                      ],
                                      child: StaffSelectScreen(),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
