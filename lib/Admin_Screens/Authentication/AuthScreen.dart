import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Widgets/AppLogo.dart';
import 'package:provider/provider.dart';
import 'widgets/AuthTabView.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int pageIndex;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
    pageIndex = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<AppTheme>(context, listen: false).white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  0.2,
              child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: AppLogo(
                    color:
                        Provider.of<AppTheme>(context, listen: false).primary,
                    size: 80,
                  )),
            ),
            Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.8,
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.transparent,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          primary: false,
                          titleSpacing: 0,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: PreferredSize(
                            preferredSize: Size.fromHeight(0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TabBar(
                                controller: _tabController,
                                indicatorSize: TabBarIndicatorSize.label,
                                unselectedLabelColor: Provider.of<AppTheme>(
                                        context,
                                        listen: false)
                                    .grey,
                                labelColor: Provider.of<AppTheme>(context,
                                        listen: false)
                                    .primary,
                                indicatorColor: Provider.of<AppTheme>(context,
                                        listen: false)
                                    .primary,
                                indicatorPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 0),
                                labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                isScrollable: true,
                                labelStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                tabs: <Widget>[
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Login     ',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Register  ',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        AuthPageView(
                            tabController: _tabController,
                            buttonText: 'Login',
                            textUnderButton:
                                'Don\'t have an account? Register'),
                        AuthPageView(
                            tabController: _tabController,
                            buttonText: 'Register',
                            textUnderButton: 'Already have an account? Login')
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
