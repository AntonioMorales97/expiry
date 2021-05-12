import 'dart:io';

import 'package:dolores/dolores.dart';
import 'package:dolores/environment.dart';
import 'package:dolores/helpers/error_handler/core/error_handler.dart';
import 'package:dolores/locator.dart';
import 'package:flutter/material.dart';

import 'helpers/error_handler/handlers/http_handler.dart';
import 'helpers/error_handler/mode/dialog_report_mode.dart';
import 'helpers/error_handler/model/error_handler_options.dart';

void main() {
  _initEnv();
  //Bloc.observer = SimpleBlocObserver();
  setupLocator();

  ErrorHandlerOptions prodOptions = ErrorHandlerOptions(
    DialogReportMode(),
    [
      HttpHandler(),
    ],
  );

  ErrorHandler(
    runAppFunction: _runApp,
    developmentConfig: prodOptions,
  );
}

void _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(Dolores());
}

void _initEnv() {
  Environment.init(
    flavor: BuildFlavor.production,
    dumbledoreBaseUrl: 'https://expiry.ddns.net/dumbledore',
    filtchBaseUrl: 'https://expiry.ddns.net/filtch',
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
