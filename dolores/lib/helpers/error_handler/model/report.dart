import 'package:dolores/helpers/error_handler/model/platform_type.dart';

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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Report {
  ///Email
  final String email;

  /// Error that has been caught
  final dynamic error;

  /// Stack trace of error
  final dynamic stackTrace;

  /// Time when it was caught
  final DateTime dateTime;

  /// Device info
  final Map<String, dynamic> deviceParameters;

  /// Application info
  final Map<String, dynamic> applicationParameters;

  /// FlutterErrorDetails data if present
  final FlutterErrorDetails errorDetails;

  /// Type of platform used
  final PlatformType platformType;

  /// Creates report instance
  Report(
      this.email,
      this.error,
      this.stackTrace,
      this.dateTime,
      this.deviceParameters,
      this.applicationParameters,
      this.errorDetails,
      this.platformType);

  /// Creates json from current instance
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      "email": email,
      "error": error.toString(),
      "dateTime": dateTime.toIso8601String(),
      "platformType": describeEnum(platformType),
    };

    json["deviceParameters"] = deviceParameters;
    json["applicationParameters"] = applicationParameters;
    json["stackTrace"] = stackTrace.toString();

    return json;
  }
}
