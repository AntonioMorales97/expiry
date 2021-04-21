import 'package:dio/dio.dart';
import 'package:dolores/ui/widgets/message_dialog.dart';
import 'package:flutter/material.dart';

import 'api_exception.dart';
import 'error_handler/core/error_handler.dart';

class ExpiryHelper {
  static Future<void> callFunctionErrorHandler(function,
      {String success, context, form}) async {
    try {
      await function;

      if (success != null) {
        await showMessageDialog(
          context,
          title: 'Meddelande',
          success: true,
          message: success,
        );
      }
      if (form != null) {
        form.reset();
      }
    } on ApiException catch (apiException) {
      await showMessageDialog(
        context,
        title: 'Felmeddelande',
        success: false,
        message: apiException.detail,
      );
    } on DioError catch (dioError, stackTrace) {
      if (dioError.type == DioErrorType.connectTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        await showMessageDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Det gick inte att kontakta våra servrar. Vänligen försök igen eller vid ett senare tillfälle.');
      } else if (dioError.type == DioErrorType.receiveTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        await showMessageDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Anropet tog för lång tid på sig. Vänligen försök igen eller vid ett senare tillfälle.');
      } else {
        throw dioError;
      }
    }
  }

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

  //TODO: What about this? Replace callFunctionErrorHandler???
  static Future<dynamic> apiCallerWrapper(
    BuildContext context,
    Future<dynamic> function, {
    final onSuccess,
    final onError,
  }) async {
    try {
      await function;

      if (onSuccess != null) {
        return await onSuccess;
      }
    } on ApiException catch (apiException) {
      if (onError != null) {
        await onError();
      }
      return await showMessageDialog(
        context,
        title: 'Felmeddelande',
        success: false,
        message: apiException.detail,
      );
    } on DioError catch (dioError, stackTrace) {
      if (dioError.type == DioErrorType.connectTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        if (onError != null) {
          await onError();
        }

        return await showMessageDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Det gick inte att kontakta våra servrar. Vänligen försök igen eller vid ett senare tillfälle.');
      } else if (dioError.type == DioErrorType.receiveTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        if (onError != null) {
          await onError();
        }
        return await showMessageDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Anropet tog för lång tid på sig. Vänligen försök igen eller vid ett senare tillfälle.');
      } else {
        throw dioError;
      }
    }
  }
}
