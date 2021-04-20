import 'dart:io';

import 'package:dolores/helpers/error_handler/model/exceptions.dart';
import 'package:dolores/helpers/error_handler/model/localization_options.dart';
import 'package:dolores/helpers/error_handler/model/platform_type.dart';
import 'package:dolores/helpers/error_handler/model/report.dart';
import 'package:dolores/helpers/error_handler/model/report_mode.dart';
import 'package:dolores/helpers/error_handler/model/status.dart';
import 'package:dolores/helpers/error_handler/utils/error_handler_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogReportModeExit extends ReportMode {
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
    return _ExitDialog(
        localizationOptions,
        true,
        () => _onAcceptReportClicked(context, report),
        () => _onRejectReportClicked(context, report));
  }

  Widget _buildMaterialDialog(Report report, BuildContext context) {
    return _ExitDialog(
        localizationOptions,
        false,
        () => _onAcceptReportClicked(context, report),
        () => _onRejectReportClicked(context, report));
  }

  Future<void> _onAcceptReportClicked(
      BuildContext context, Report report) async {
    await super.onActionConfirmed(report);
    exit(1);
  }

  Future<void> _onRejectReportClicked(
      BuildContext context, Report report) async {
    await super.onActionRejected(report);
    exit(1);
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Android, PlatformType.iOS];
}

class _ExitDialog extends StatefulWidget {
  final LocalizationOptions _localizationOptions;
  final bool _isCupertino;

  const _ExitDialog(localizationOptions, isCupertino, onAccept, onReject)
      : _localizationOptions = localizationOptions,
        _isCupertino = isCupertino,
        _onAccept = onAccept,
        _onReject = onReject;

  final Future<void> Function() _onAccept;
  final Future<void> Function() _onReject;

  @override
  _ExitDialogState createState() => _ExitDialogState();
}

class _ExitDialogState extends State<_ExitDialog> {
  Status _status = Status.INIT;
  String errorText = '';

  _accept() async {
    try {
      setState(() {
        _status = Status.LOADING;
      });
      await widget._onAccept();
    } catch (error) {
      _handleError(error);
    }
  }

  _reject() async {
    try {
      await widget._onReject();
    } catch (error) {
      _handleError(error);
    }
  }

  _handleError(ErrorHandlerException error) {
    var displayErrorMsg = 'Sorry, something went wrong';
    String errorMsg = error.getMessage();
    if (errorMsg != null && errorMsg.isNotEmpty) displayErrorMsg = errorMsg;
    setState(() {
      _status = Status.ERROR;
      errorText = displayErrorMsg;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isCupertino) {
      return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoAlertDialog(
          title: _status == Status.LOADING
              ? Text('')
              : Text(widget._localizationOptions.dialogReportModeTitle),
          content: _status == Status.LOADING
              ? Center(
                  heightFactor: 2,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  _status == Status.INIT
                      ? widget._localizationOptions.dialogReportModeDescription
                      : errorText,
                ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                _status == Status.INIT || _status == Status.LOADING
                    ? widget._localizationOptions.dialogReportModeAccept
                    : widget._localizationOptions.retry,
              ),
              onPressed: () => _accept(),
            ),
            CupertinoDialogAction(
              child: Text(
                _status == Status.INIT || _status == Status.LOADING
                    ? widget._localizationOptions.dialogReportModeCancel
                    : widget._localizationOptions.close,
              ),
              onPressed: () => _reject(),
            ),
          ],
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: _status == Status.LOADING
              ? Text('')
              : Text(widget._localizationOptions.dialogReportModeTitle),
          content: _status == Status.LOADING
              ? Center(
                  heightFactor: 2,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  _status == Status.INIT
                      ? widget._localizationOptions.dialogReportModeDescription
                      : errorText,
                ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                _status == Status.INIT || _status == Status.LOADING
                    ? widget._localizationOptions.dialogReportModeAccept
                    : widget._localizationOptions.retry,
              ),
              onPressed: _status == Status.LOADING ? null : () => _accept(),
            ),
            ElevatedButton(
              child: Text(
                _status == Status.INIT || _status == Status.LOADING
                    ? widget._localizationOptions.dialogReportModeCancel
                    : widget._localizationOptions.close,
              ),
              onPressed: _status == Status.LOADING ? null : () => _reject(),
            ),
          ],
        ),
      );
    }
  }
}
