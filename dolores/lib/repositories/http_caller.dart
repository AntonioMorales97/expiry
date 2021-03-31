import 'package:dio/dio.dart';

class HttpCaller {
  static const String APPLICATION_JSON = 'application/json';
  static const String BEARER_PREFIX = 'Bearer ';

  final Dio _dio = Dio();
  static final HttpCaller _httpCaller = HttpCaller._internal();

  factory HttpCaller() {
    return _httpCaller;
  }

  HttpCaller._internal();

  Future<dynamic> doPost(String path,
      {HttpHeaders headers, Map<String, dynamic> body}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      _dio.post(path, data: body, options: Options(headers: extractedHeaders));
    } on DioError catch (error) {
      //TODO: Implement
      _handleError();
    }
  }

  Future<dynamic> doGet(String path, {HttpHeaders headers}) async {
    //TODO: Implement
  }

  Map<String, String> _extractHeaders(HttpHeaders headers) {
    final Map<String, String> headersMap = {};

    if (headers == null) {
      headersMap['Content-Type'] = APPLICATION_JSON;
      headersMap['Accept'] = APPLICATION_JSON;
      return headersMap;
    }

    headersMap['Content-Type'] = headers.contentType ?? APPLICATION_JSON;
    headersMap['Accept'] = headers.accept ?? APPLICATION_JSON;

    if (headers.authorizationToken != null) {
      headersMap['Authorization'] = BEARER_PREFIX + headers.authorizationToken;
    }

    return headersMap;
  }

  void _handleError() {
    //TODO: Implement
  }
}

class HttpHeaders {
  String authorizationToken;
  String contentType;
  String accept;

  HttpHeaders({
    String authorizationToken,
    String contentType,
    String accept,
  }) {
    this.authorizationToken = authorizationToken;
    this.contentType = contentType;
    this.accept = accept;
  }
}
