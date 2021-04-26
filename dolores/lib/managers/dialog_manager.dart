import 'package:dolores/models/alert_models.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(AlertRequest request) {
    ///TODO get the right theme colors + make button a wee bit bigger?
    print(Theme.of(context).colorScheme.onPrimary);
    Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () =>
            _dialogService.dialogComplete(AlertResponse(confirmed: false)),
        type: _getType(request.success),
        buttons: [
          DialogButton(
            color: _getButtonColor(request.success),
            child: Text(
              request.buttonTitle,
              style: TextStyle(
                  color: _getTextColor(request.success),
                  letterSpacing: 2,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              _dialogService.dialogComplete(AlertResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          )
        ],
        style: AlertStyle(
          titleStyle:
              TextStyle(color: _getTextColor(request.success), fontSize: 26),
          descStyle:
              TextStyle(color: _getTextColor(request.success), fontSize: 16),
          titleTextAlign: TextAlign.center,
          descTextAlign: TextAlign.center,
        )).show();
  }

  _getType(success) {
    if (success) return AlertType.success;
    return AlertType.error;
  }

  ///TODO theme colors not workign??
  _getButtonColor(success) {
    if (success) return Color.fromRGBO(50, 77, 229, 1);

    ///Theme.of(context).buttonColor;
    return Colors.red.shade400;

    ///Theme.of(context).errorColor;
  }

  _getTextColor(success) {
    if (success) return Colors.black;

    ///Theme.of(context).colorScheme.onPrimary;
    return Colors.black;

    ///Theme.of(context).colorScheme.onError;
  }
}
