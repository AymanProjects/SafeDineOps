import 'package:SafeDineOps/Admin_Screens/Authentication/OTPScreen.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Authentication.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Staff_Screens/StaffHomeScreen.dart';
import 'package:SafeDineOps/Utilities/Validations.dart';
import 'package:SafeDineOps/Widgets/SafeDineButton.dart';
import 'package:SafeDineOps/Widgets/SafeDineField.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthPageView extends StatefulWidget {
  final TabController tabController;
  final String textUnderButton;
  final String buttonText;

  AuthPageView({this.tabController, this.textUnderButton, this.buttonText});

  @override
  _AuthPageViewState createState() => _AuthPageViewState();
}

class _AuthPageViewState extends State<AuthPageView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _autoValidate = false;
  bool _loading = false;
  bool _isAdmin = false;
  String _restaurantName = '';

  @override
  void setState(func) {
    if (mounted) {
      super.setState(func);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            widget.buttonText == 'Login'
                ? SizedBox()
                : SafeDineField(
                    icon: Icon(
                      Icons.restaurant,
                    ),
                    hintText: 'Restaurant name',
                    onChanged: (val) {
                      _restaurantName = val;
                    },
                    validator: (val) => Validations.isEmptyValidation(val),
                  ),
            SizedBox(
              height: 20,
            ),
            SafeDineField(
              icon: Icon(
                Icons.email,
              ),
              hintText: 'Email',
              isEmail: true,
              onChanged: (val) {
                _email = val;
              },
              validator: (val) => Validations.emailValidation(val),
            ),
            SizedBox(
              height: 20,
            ),
            SafeDineField(
              icon: Icon(
                Icons.lock,
              ),
              hintText: 'Password',
              isPassword: true,
              onChanged: (val) {
                _password = val;
              },
              validator: (val) => Validations.passwordValidation(val),
            ),
            widget.buttonText == 'Login'
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              child: Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    _isAdmin = value;
                                  });
                                },
                                value: _isAdmin,
                              ),
                            ),
                            Text('login as admin?'),
                          ],
                        ),
                        InkWell(
                          child: Text(
                            'forgot password?',
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          ),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            SafeDineSnackBar.showTextFieldDialog(
                              isEmail: true,
                              hint: 'Email',
                              icon: Icon(Icons.email),
                              initialData: _email,
                              context: context,
                              message: 'Enter your email to receive a link',
                              negativeActionText: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                              negativeAction: () {
                                Navigator.pop(context);
                              },
                              positiveActionText: Text(
                                'Send',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              positiveAction: (email, controller) async {
                                try {
                                  await Restaurant(email: email)
                                      .forgotPassword();
                                  if (controller?.isDisposed == false) {
                                    controller.dismiss();
                                  }
                                  SafeDineSnackBar.showNotification(
                                    context: context,
                                    msg: 'Email has been sent  ✉️',
                                    type: SnackbarType.Success,
                                  );
                                } on PlatformException catch (e) {
                                  SafeDineSnackBar.showNotification(
                                    type: SnackbarType.Error,
                                    context: context,
                                    msg: FirebaseException
                                        .generateReadableMessage(e),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 35,
            ),
            SafeDineButton(
              fontSize: 16,
              text: widget.buttonText,
              loading: _loading,
              function: () {
                hideKeyboard();
                buttonPressed(context);
              },
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  widget.tabController
                      .animateTo(widget.buttonText == 'Login' ? 1 : 0);
                },
                child: Text(
                  widget.textUnderButton,
                  style: TextStyle(fontSize: 13),
                )),
          ],
        ),
      ),
    );
  }

  void buttonPressed(context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        Restaurant restaurant = new Restaurant(
            email: _email, password: _password, name: _restaurantName);
        if (widget.buttonText == 'Login') {
          await restaurant.login();
        } else {
          _isAdmin = true;
          await restaurant.register();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _isAdmin ? OTPScreen() : StaffHomeScreen(),
          ),
        );
      } on PlatformException catch (exception) {
        String msg = FirebaseException.generateReadableMessage(
            exception); //firebase exception happened
        SafeDineSnackBar.showNotification(
            context: context, type: SnackbarType.Error, msg: msg);
      } catch (e) {
        SafeDineSnackBar.showNotification(
            context: context,
            msg: 'Undefined error happened',
            type: SnackbarType.Error);
      }
    }
    setState(() {
      _loading = false;
      _autoValidate = true;
    });
  }

  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
