import 'package:SafeDineOps/Utilities/AppTheme.dart';
import 'package:SafeDineOps/Utilities/Validations.dart';
import 'package:SafeDineOps/Widgets/SafeDineField.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SnackbarType {
  Error,
  Warning,
  Success,
  CartNotification,
}

class SafeDineSnackBar {
  static FlashController _previousController;

  static void showConfirmationDialog({
    @required BuildContext context,
    @required String message,
    @required Widget negativeActionText,
    @required Function negativeAction,
    @required Widget positiveActionText,
    @required Function positiveAction,
  }) {
    showFlash(
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      persistent: true,
      builder: (context, controller) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Flash.dialog(
              enableDrag: true,
              controller: controller,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: FlashBar(
                shouldIconPulse: false,
                message: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              if (positiveAction != null) positiveAction();
                              if (controller?.isDisposed == false)
                                controller.dismiss();
                            },
                            child: positiveActionText),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                            onTap: () {
                              if (negativeAction != null) negativeAction();
                              if (controller?.isDisposed == false)
                                controller.dismiss();
                            },
                            child: negativeActionText),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void showNotification(
      {@required SnackbarType type,
      @required BuildContext context,
      @required String msg,
      Function ontap,
      String actionName = 'Dismiss',
      Function onActionTap,
      int duration = 4}) {
    Color color;
    IconData icon;
    bool dismissOnClick = false;
    if (type == SnackbarType.Error) {
      color = Colors.red;
      icon = Icons.error_outline;
    } else if (type == SnackbarType.Warning) {
      color = Colors.orange;
      icon = Icons.info_outline;
    } else if (type == SnackbarType.Success) {
      color = Colors.green;
      icon = Icons.done;
    } else if (type == SnackbarType.CartNotification) {
      color = Provider.of<AppTheme>(context, listen: false).primary;
      icon = CupertinoIcons.cart;
      dismissOnClick = true;
    }
    _snackBar(
      context: context,
      duration: duration,
      msg: msg,
      ontap: () {
        if (ontap != null) ontap();
        if (_previousController?.isDisposed == false && dismissOnClick)
          _previousController.dismiss();
      },
      actionName: actionName,
      onActionTap: () {
        if (onActionTap != null) onActionTap();
      },
      icon: icon,
      color: color,
    );
  }

  static void _snackBar(
      {BuildContext context,
      String msg,
      Color color,
      String actionName,
      Function onActionTap,
      int duration,
      IconData icon,
      Function ontap}) {
    if (_previousController?.isDisposed == false) _previousController.dismiss();
    _previousController = FlashController(context, (context, controller) {
      return Flash(
        controller: controller,
        onTap: ontap,
        backgroundColor: color,
        child: FlashBar(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          message: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Text(
                    msg,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (_previousController?.isDisposed == false)
                    _previousController.dismiss();
                  onActionTap();
                },
                child: Text(
                  actionName,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.45),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    },
        duration: Duration(seconds: duration),
        persistent: true,
        transitionDuration: Duration(milliseconds: 400));
    _previousController.show();
  }

  static void showTextFieldDialog({
    @required String initialData,
    @required BuildContext context,
    @required String message,
    @required Widget positiveActionText,
    @required Function positiveAction,
    @required Widget negativeActionText,
    @required Function negativeAction,
    @required String hint,
    @required Icon icon,
    @required bool isEmail,
  }) {
    String textFieldValue = initialData;
    final _formKey = GlobalKey<FormState>();
    bool _loading = false;
    showFlash(
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      persistent: true,
      builder: (context, controller) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Flash.dialog(
              enableDrag: true,
              controller: controller,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: FlashBar(
                shouldIconPulse: false,
                title: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                message: Form(
                  key: _formKey,
                  child: SafeDineField(
                    initialValue: initialData,
                    validator: isEmail
                        ? (val) => Validations.emailValidation(val)
                        : (val) => Validations.isEmptyValidation(val),
                    hintText: hint,
                    icon: icon,
                    onChanged: (value) {
                      textFieldValue = value;
                    },
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              if (negativeAction != null)
                                negativeAction(controller);
                              if (controller?.isDisposed == false) {
                                controller.dismiss();
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: negativeActionText),
                        SizedBox(
                          width: 25,
                        ),
                        _loading
                            ? Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : InkWell(
                                onTap: () async {
                                  if (positiveAction != null) {
                                    if (_formKey.currentState.validate()) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      setState(() {
                                        _loading = true;
                                      });
                                      await positiveAction(
                                          textFieldValue, controller);
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  }
                                },
                                child: positiveActionText),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
