import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SafeDineField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChanged;
  final bool autoValidate;
  final bool isPassword;
  final bool isEmail;
  final Icon icon;
  final bool enabled;
  final int maxLines;
  final String initialValue;
  final bool isNumber;
  final Color color;
  SafeDineField(
      {this.enabled = true,
      this.autoValidate = false,
      this.isNumber = false,
      this.color,
      this.hintText = '',
      this.validator,
      this.initialValue,
      this.onChanged,
      this.isPassword = false,
      this.isEmail = false,
      this.icon,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorMaxLines: 1,
        hintMaxLines: 1,
        suffixIcon: icon,
        contentPadding: EdgeInsets.all(16.0),
        filled: true,
        fillColor:
            color ?? Provider.of<AppTheme>(context, listen: false).darkWhite,
        enabledBorder: border(context: context),
        focusedBorder: border(context: context, isSelected: true),
        errorBorder: border(context: context),
        disabledBorder: border(context: context),
        focusedErrorBorder: border(context: context, isSelected: true),
      ),
      cursorColor: Theme.of(context).primaryColor,
      obscureText: isPassword ? true : false,
      validator: (val) {
        if (validator != null)
          return validator(val);
        else
          return null;
      },
      autovalidate: autoValidate,
      onChanged: (val) {
        if (onChanged != null) onChanged(val);
      },
      maxLines: maxLines,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (isNumber ? TextInputType.number : TextInputType.text),
    );
  }

  OutlineInputBorder border({bool isSelected = false, context}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Provider.of<AppTheme>(context, listen: false).darkWhite,
        width: 0.5,
        style: BorderStyle.solid,
      ),
    );
  }
}
