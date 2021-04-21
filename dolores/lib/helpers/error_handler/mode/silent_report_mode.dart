import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';
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

import 'package:flutter/widgets.dart';

class SilentReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) async {
    // no action needed, request is automatically accepted
    try {
      await super.onActionConfirmed(report);
    } catch (error) {
      print(error);
      //If fail, fail silently (?)
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS];
}
