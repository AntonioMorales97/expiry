import 'package:dolores/helpers/error_handler/handlers/console_handler.dart';
import 'package:dolores/helpers/error_handler/handlers/http_handler.dart';
import 'package:dolores/helpers/error_handler/mode/dialog_report_mode.dart';
import 'package:dolores/helpers/error_handler/mode/silent_report_mode.dart';
import 'package:dolores/helpers/error_handler/model/report_handler.dart';
import 'package:dolores/helpers/error_handler/model/report_mode.dart';

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

import 'localization_options.dart';

class ErrorHandlerOptions {
  /// Handlers that should be used
  final List<ReportHandler> handlers;

  /// Timeout for handlers which uses long-running action. In milliseconds.
  final int handlerTimeout;

  /// Report mode that should be called if new report appears
  final ReportMode reportMode;

  /// Report mode for silent reporting - mostly used for handled errors
  final ReportMode silenceReportMode = SilentReportMode();

  /// Localization options (translations)
  final List<LocalizationOptions> localizationOptions;

  /// Explicit report modes map which will be used to trigger specific report mode
  /// for specific error
  final Map<String, ReportMode> explicitExceptionReportModesMap;

  /// Explicit report handler map which will be used to trigger specific report
  /// report handler for specific error
  final Map<String, ReportHandler> explicitExceptionHandlersMap;

  /// Custom parameters which will be used in report handler
  final Map<String, dynamic> customParameters;

  /// Builds catcher options instance
  ErrorHandlerOptions(this.reportMode, this.handlers,
      {this.handlerTimeout = 5000,
      this.customParameters = const <String, dynamic>{},
      this.localizationOptions = const [],
      this.explicitExceptionReportModesMap = const {},
      this.explicitExceptionHandlersMap = const {}});

  /// Builds default catcher options development instance
  ErrorHandlerOptions.getDevelopmentOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = DialogReportMode(),
        handlerTimeout = 5000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        this.explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {};

  /// Builds default catcher options production instance
  ErrorHandlerOptions.getProductionOptions()
      : this.handlers = [HttpHandler()],
        this.reportMode = SilentReportMode(),
        handlerTimeout = 6000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        this.explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {};
}
