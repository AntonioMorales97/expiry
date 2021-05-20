import 'package:dolores/dolores.dart';
import 'package:dolores/environment.dart';
import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:dolores/helpers/simple_bloc_observer.dart';
import 'package:dolores/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helpers/error_handler/handlers/console_handler.dart';
import 'helpers/error_handler/mode/dialog_report_mode.dart';
import 'helpers/error_handler/model/error_handler_options.dart';

void main() {
  _initEnv();
  Bloc.observer = SimpleBlocObserver();
  setupLocator();

  ErrorHandlerOptions developmentOptions = ErrorHandlerOptions(
    DialogReportMode(),
    [
      ConsoleHandler(),
      //HttpHandler()
    ],
  );

  ErrorHandler(
    runAppFunction: _runApp,
    developmentConfig: developmentOptions,
  );
}

void _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Dolores());
}

void _initEnv() {
  Environment.init(
    flavor: BuildFlavor.development,
    dumbledoreBaseUrl: 'http://10.0.2.2:9091',
    filtchBaseUrl: 'http://10.0.2.2:9092',
  );
}
