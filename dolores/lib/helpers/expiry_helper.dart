import 'package:dolores/ui/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

import 'api_exception.dart';

class ExpiryHelper {
  //TODO Better name :-)?
  static Future<void> callFunctionErrorHandler(function,
      {String success, context, form}) async {
    try {
      await function;
      if (success != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(success: success);
            });
      }
      if (form != null) {
        form.reset();
      }
    } on ApiException catch (apiException) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error: apiException.detail);
          });
    }
  }
}
