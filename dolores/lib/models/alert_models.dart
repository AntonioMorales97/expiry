import 'package:flutter/widgets.dart';

class AlertRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final bool success;

  AlertRequest({
    @required this.title,
    @required this.description,
    @required this.buttonTitle,
    this.success = false,
  });
}

class AlertResponse {
  final String fieldOne;
  final String fieldTwo;
  final bool confirmed;

  AlertResponse({
    this.fieldOne,
    this.fieldTwo,
    this.confirmed,
  });
}
