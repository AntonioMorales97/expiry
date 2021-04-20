///
/// Copyright (C) 2020 Catcher
/// Licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
/// see: https://github.com/jhomlala/catcher
///
/// No NOTICE file.
///
/// Modifications Copyright (C) 2021 Expiry
///
///

import 'package:dolores/helpers/error_handler/model/exceptions.dart';
import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';
import 'package:dolores/helpers/error_handler/model/report_handler.dart';
import 'package:dolores/helpers/error_handler/utils/error_handler_utils.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';

import 'package:logging/logging.dart';

class HttpHandler extends ReportHandler {
  final Logger _logger = Logger("HttpHandler");

  final int requestTimeout;
  final int responseTimeout;

  HttpHandler({
    this.requestTimeout = 5000,
    this.responseTimeout = 5000,
  })  : assert(requestTimeout != null, "requestTimeout can't be null"),
        assert(responseTimeout != null, "responseTimeout can't be null");

  @override
  Future<void> handle(Report error) async {
    if (error.platformType != PlatformType.Web) {
      if (!(await ErrorHandlerUtils.isInternetConnectionAvailable())) {
        _printLog("No internet connection available");
        throw NoInternetException('No internet connection available.');
      }
    }

    await _sendPost(error);
  }

  Future<void> _sendPost(Report error) async {
    try {
      var json = error.toJson();

      _printLog("Sending error to Dumbledore...");

      final dumbledoreRepo = DumbledoreRepository();
      final response = await dumbledoreRepo.sendErrorLog(json);

      _printLog("Error sent!");

      _printLog("HttpHandler response: $response");
    } catch (error, stackTrace) {
      _printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      throw FailException(
          'Failed to send the error log. Please try again or restart the application.');
    }
  }

  void _printLog(String log) {
    _logger.info(log);
  }

  @override
  String toString() {
    return 'HttpHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS];
}
