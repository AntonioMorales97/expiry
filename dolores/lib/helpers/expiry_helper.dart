import 'package:dolores/ui/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

import 'api_exception.dart';

class ExpiryHelper {
  static Future<void> callFunctionErrorHandler(function,
      {String success, context, form}) async {
    try {
      await function;
      if (success != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ErrorSuccessDialog(success: true, message: success);
            });
      }
      if (form != null) {
        form.reset();
      }
    } on ApiException catch (apiException) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorSuccessDialog(
                success: false, message: apiException.detail);
          });
    }
  }
}
