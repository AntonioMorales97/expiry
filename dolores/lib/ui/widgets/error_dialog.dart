import 'package:flutter/material.dart';

class ErrorSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool success;

  const ErrorSuccessDialog({
    @required this.title,
    @required this.message,
    @required this.success,
  });
  getButtonColor(context) {
    if (success) return Theme.of(context).buttonColor;

    return Theme.of(context).errorColor;
  }

  getTextColor(context) {
    if (success) return Theme.of(context).colorScheme.onPrimary;
    return Theme.of(context).colorScheme.onError;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(top: 20.0),
      titlePadding: EdgeInsets.only(top: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32))),
      scrollable: true,
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text(message)),
                    ],
                  ),
                ],
              ),
            ),
            Material(
              color: getButtonColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                  bottomRight: Radius.circular(32.0),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: getTextColor(context), letterSpacing: 2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [],
    );
  }
}
