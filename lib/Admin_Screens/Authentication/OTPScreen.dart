import 'dart:async';
import 'dart:math';

import 'package:SafeDineOps/Admin_Screens/Home/AdminHomeScreen.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Authentication.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:SafeDineOps/Services/Mailer.dart';
import 'package:SafeDineOps/Widgets/FadeRouteAnimation.dart';
import 'package:SafeDineOps/Widgets/SafeDineButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  OTPScreen({this.email});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String otp_Digits = '';

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    otp_Digits = (1000 + Random().nextInt(9999 - 1000)).toString();
    String email = Provider.of<Restaurant>(context, listen: false).getEmail();
    Mailer(otp_code: otp_Digits, recipientsEmail: email);
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
                    TextSpan(text: widget.email),
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
                    otp_Digits == currentText) {
                  Navigator.push(
                    context,
                    FadeRouteAnimation(
                      page: AdminHomeScreen(),
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
