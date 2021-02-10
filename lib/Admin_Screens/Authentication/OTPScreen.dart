import 'dart:math';
import 'package:SafeDineOps/Admin_Screens/Authentication/widgets/OTPWidget.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/Mailer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String otpDigits = (1000 + Random().nextInt(9999 - 1000)).toString();
    String email = Provider.of<Restaurant>(context, listen: false).getEmail();
    Mailer(otp_code: otpDigits, recipientsEmail: email);
    print(otpDigits);
    return OTPWidget(otpCode: otpDigits);
  }
}
