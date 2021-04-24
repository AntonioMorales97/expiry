import 'package:dolores/ui/widgets/message_dialog.dart';
import 'package:flutter/material.dart';

import 'dolores_error.dart';

class ExpiryHelper {
  static Future<dynamic> showMessageDialog(BuildContext context,
      {@required String title,
      @required bool success,
      @required String message}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: title,
          success: success,
          message: message,
        );
      },
    );
  }

  static Future<dynamic> apiCallerWrapper(
    BuildContext context,
    Future<dynamic> function, {
    Function isMounted,
    final onSuccess,
    final onError,
    String successMessage,
  }) async {
    try {
      await function;

      if (onSuccess != null && isMounted()) {
        await onSuccess();
      }

      if (successMessage != null) {
        return await showMessageDialog(
          context,
          title: 'Meddelande',
          success: true,
          message: successMessage,
        );
      }
    } on DoloresError catch (apiException) {
      if (!isMounted()) {
        return;
      }

      if (onError != null) {
        await onError();
      }
      return await showMessageDialog(
        context,
        title: 'Felmeddelande',
        success: false,
        message: apiException.detail,
      );
    }
  }

  static Future<dynamic> showErrorOrSuccessDialogs(
    BuildContext context,
    DoloresError error, {
    final onSuccess,
    final onError,
    String successMessage,
  }) async {
    if (onSuccess != null) {
      await onSuccess();
    }

    if (successMessage != null) {
      return await showMessageDialog(
        context,
        title: 'Meddelande',
        success: true,
        message: successMessage,
      );
    }
    if (error != null) {
      if (onError != null) {
        await onError();
      }
      return await showMessageDialog(
        context,
        title: 'Felmeddelande',
        success: false,
        message: error.detail,
      );
    }
  }
}
