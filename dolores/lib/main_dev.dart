import 'package:dolores/dolores.dart';
import 'package:dolores/environment.dart';
import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:flutter/material.dart';

import 'helpers/error_handler/handlers/console_handler.dart';
import 'helpers/error_handler/mode/dialog_report_mode.dart';
import 'helpers/error_handler/model/error_handler_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initEnv();

  ErrorHandlerOptions developmentOptions = ErrorHandlerOptions(
    DialogReportMode(),
    [
      ConsoleHandler(),
    ],
  );

  ErrorHandler(
    rootWidget: Dolores(),
    developmentConfig: developmentOptions,
  );
}

void _initEnv() {
  Environment.init(
    flavor: BuildFlavor.development,
    dumbledoreBaseUrl: 'http://10.0.2.2:9091',
    filtchBaseUrl: 'http://10.0.2.2:9092',
  );
}
