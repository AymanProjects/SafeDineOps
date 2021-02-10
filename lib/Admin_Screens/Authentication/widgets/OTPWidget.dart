import 'dart:async';
import 'package:SafeDineOps/Admin_Screens/Home/AdminHomeScreen.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Widgets/FadeRouteAnimation.dart';
import 'package:SafeDineOps/Widgets/SafeDineButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPWidget extends StatefulWidget {
  final String otpCode;
  OTPWidget({this.otpCode = ''});
  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ListView(
        padding: EdgeInsets.only(top: 170),
        children: <Widget>[
          Text(
            'Email Code Verification',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: RichText(
              text: TextSpan(
                  text: "Enter the code sent to ",
                  children: [
                    TextSpan(
                        text: Provider.of<Restaurant>(context, listen: false)
                            .getEmail()),
                  ],
                  style: TextStyle(color: Colors.black54, fontSize: 15)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.scale,
                  validator: (v) {
                    if (v.length < 4) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue,
                    disabledColor: Colors.blue,
                    selectedColor: Colors.blue,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(fontSize: 20, height: 1.6),
                  backgroundColor: Colors.transparent,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            child: SafeDineButton(
              text: 'Verify',
              function: () {
                if (formKey.currentState.validate() &&
                    widget.otpCode == currentText) {
                      Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);
                  Navigator.push(
                    context,
                    FadeRouteAnimation(
                      page: Provider<Restaurant>.value(
                        value: restaurant,
                        child: AdminHomeScreen(),
                      ),
                    ),
                  );
                } else {
                  errorController.add(ErrorAnimationType.shake);
                  setState(() {
                    hasError = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
