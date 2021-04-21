import 'package:dio/dio.dart';
import 'package:dolores/ui/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

import 'api_exception.dart';
import 'error_handler/core/error_handler.dart';

class ExpiryHelper {
  static Future<void> callFunctionErrorHandler(function,
      {String success, context, form}) async {
    try {
      await function;
      if (success != null) {
        _showErrorSuccessDialog(
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
      _showErrorSuccessDialog(
        context,
        title: 'Felmeddelande',
        success: false,
        message: apiException.detail,
      );
    } on DioError catch (dioError, stackTrace) {
      if (dioError.type == DioErrorType.connectTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        _showErrorSuccessDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Det gick inte att kontakta våra servrar. Vänligen försök igen eller vid ett senare tillfälle.');
      } else if (dioError.type == DioErrorType.receiveTimeout) {
        ErrorHandler.reportCheckedError(dioError, stackTrace);
        _showErrorSuccessDialog(context,
            title: 'Felmeddelande',
            success: false,
            message:
                'Anropet tog för lång tid på sig. Vänligen försök igen eller vid ett senare tillfälle.');
      } else {
        throw dioError;
      }
    }
  }

  static void _showErrorSuccessDialog(BuildContext context,
      {@required String title,
      @required bool success,
      @required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorSuccessDialog(
          title: title,
          success: success,
          message: message,
        );
      },
    );
  }
}
