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

import 'dart:io';

import 'package:flutter/cupertino.dart';

class ErrorHandlerUtils {
  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (exception) {
      return Future.value(false);
    }
  }

  static bool isCupertinoAppAncestor(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
  }
}
