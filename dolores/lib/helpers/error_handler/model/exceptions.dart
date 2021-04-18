class ErrorHandlerException implements Exception {
  final String errorTitle;
  final String errorMessage;

  const ErrorHandlerException([this.errorTitle, this.errorMessage]);

  @override
  String toString() {
    return '$errorTitle: $errorMessage';
  }

  String getMessage() {
    return '$errorMessage';
  }

  String getTitle() {
    return '$errorTitle';
  }
}

class NoInternetException extends ErrorHandlerException {
  const NoInternetException([message])
      : super('No Internet', message ?? 'Could not connect to the Internet');
}

class UnknownException extends ErrorHandlerException {
  const UnknownException([message])
      : super('Unknown Error', message ?? 'An unknown error occurred');
}

class FailException extends ErrorHandlerException {
  const FailException([message])
      : super('Fail', message ?? 'Failed to do the requested action');
}

class TimeoutException extends ErrorHandlerException {
  const TimeoutException([message])
      : super('Timeout',
            message ?? 'Failed because it took too long. Please try again');
}

class NotSupportedException extends ErrorHandlerException {
  const NotSupportedException([message])
      : super('Not Supported', message ?? 'The error handler is not supported');
}

class SilentLogException extends ErrorHandlerException {
  const SilentLogException([message])
      : super(
            'SilentLogException', message ?? 'Silent log exception triggered');
}

class ComponentLogException extends ErrorHandlerException {
  const ComponentLogException([message])
      : super('ComponentLogException',
            message ?? 'Something went wrong in a component');
}
