class ApiException implements Exception {
  final String detail;
  final int status;
  List<ErrorDetail> errors;

  ApiException.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        detail = json['detail'],
        errors = json['errors'] == null
            ? null
            : (json['errors'] as List)
                .map((error) => ErrorDetail.fromJson(error))
                .toList();

  @override
  String toString() {
    return 'ApiException: {detail: $detail, status: $status, errors: $errors}';
  }
}

class ErrorDetail {
  String detail;
  String path;
  String queryParam;

  ErrorDetail.fromJson(Map<String, dynamic> json)
      : detail = json['detail'],
        path = json['path'],
        queryParam = json['queryParam'];

  @override
  String toString() {
    return 'ErrorDetail: {detail: $detail, path: $path, queryParam: $queryParam}';
  }
}
