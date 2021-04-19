import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';
import 'package:dolores/helpers/error_handler/model/report_handler.dart';
import 'package:logging/logging.dart';

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

class ConsoleHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  Logger _logger = Logger("ConsoleHandler");

  ConsoleHandler(
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = false})
      : assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null");

  @override
  Future<void> handle(Report report) {
    _logger.info(
        "============================== ERROR LOG ==============================");
    _logger.info("Crash occurred on ${report.dateTime}");
    _logger.info("");
    _logger.info("Email ${report.email}");
    _logger.info("");
    if (enableDeviceParameters) {
      _printDeviceParametersFormatted(report.deviceParameters);
      _logger.info("");
    }
    if (enableApplicationParameters) {
      _printApplicationParametersFormatted(report.applicationParameters);
      _logger.info("");
    }
    _logger.info("---------- ERROR ----------");
    _logger.info("${report.error}");
    _logger.info("");
    if (enableStackTrace) {
      _printStackTraceFormatted(report.stackTrace);
    }
    if (enableCustomParameters) {
      _printCustomParametersFormatted(report.customParameters);
    }
    _logger.info(
        "======================================================================");

    return Future.value();
  }

  void _printDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    _logger.info("------- DEVICE INFO -------");
    for (var entry in deviceParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printApplicationParametersFormatted(
      Map<String, dynamic> applicationParameters) {
    _logger.info("------- APP INFO -------");
    for (var entry in applicationParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printCustomParametersFormatted(Map<String, dynamic> customParameters) {
    _logger.info("------- CUSTOM INFO -------");
    for (var entry in customParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printStackTraceFormatted(StackTrace stackTrace) {
    _logger.info("------- STACK TRACE -------");
    for (var entry in stackTrace.toString().split("\n")) {
      _logger.info("$entry");
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS];
}
