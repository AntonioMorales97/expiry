import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';
import 'package:dolores/helpers/error_handler/model/report_mode.dart';
import 'package:dolores/helpers/error_handler/utils/error_handler_utils.dart';

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  Future _showDialog(Report report, BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    if (ErrorHandlerUtils.isCupertinoAppAncestor(context)) {
      return showCupertinoDialog<void>(
          context: context,
          builder: (context) => _buildCupertinoDialog(report, context));
    } else {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildMaterialDialog(report, context));
    }
  }

  Widget _buildCupertinoDialog(Report report, BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(localizationOptions.dialogReportModeTitle),
      content: Text(localizationOptions.dialogReportModeDescription),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(localizationOptions.dialogReportModeAccept),
          onPressed: () => _onAcceptReportClicked(context, report),
        ),
        CupertinoDialogAction(
          child: Text(localizationOptions.dialogReportModeCancel),
          onPressed: () => _onCancelReportClicked(context, report),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(Report report, BuildContext context) {
    return AlertDialog(
      title: Text(localizationOptions.dialogReportModeTitle),
      content: Text(localizationOptions.dialogReportModeDescription),
      actions: <Widget>[
        FlatButton(
          child: Text(localizationOptions.dialogReportModeAccept),
          onPressed: () => _onAcceptReportClicked(context, report),
        ),
        FlatButton(
          child: Text(localizationOptions.dialogReportModeCancel),
          onPressed: () => _onCancelReportClicked(context, report),
        ),
      ],
    );
  }

  void _onAcceptReportClicked(BuildContext context, Report report) {
    super.onActionConfirmed(report);
    Navigator.pop(context);
  }

  void _onCancelReportClicked(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS];
}
