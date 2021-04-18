import 'package:dolores/helpers/error_handler/mode/report_mode_action.dart';
import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';

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
import 'localization_options.dart';

abstract class ReportMode {
  ReportModeAction _reportModeAction;
  LocalizationOptions _localizationOptions;

  /// Set report mode action.
  void setReportModeAction(ReportModeAction reportModeAction) {
    this._reportModeAction = reportModeAction;
  }

  /// Set localization options (translations) to this report mode
  void setLocalizationOptions(LocalizationOptions localizationOptions) {
    this._localizationOptions = localizationOptions;
  }

  /// Code which should be triggered if new error has been caught and core
  /// creates report about this.
  void requestAction(Report report, BuildContext context);

  /// On user has accepted report
  Future<void> onActionConfirmed(Report report) async {
    return await _reportModeAction.onActionConfirmed(report);
  }

  /// On user has rejected report
  Future<void> onActionRejected(Report report) async {
    await _reportModeAction.onActionRejected(report);
  }

  /// Check if given report mode requires context to run
  bool isContextRequired() {
    return false;
  }

  /// Get currently used localization options
  LocalizationOptions get localizationOptions => _localizationOptions;

  /// Get supported platform list
  List<PlatformType> getSupportedPlatforms();
}
