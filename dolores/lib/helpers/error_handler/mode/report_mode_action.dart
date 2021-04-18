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

abstract class ReportModeAction {
  ///Code which should be triggered if report mode has been confirmed
  Future<void> onActionConfirmed(Report report);

  /// Code which should be triggered if report mode has been rejected
  Future<void> onActionRejected(Report report);
}
