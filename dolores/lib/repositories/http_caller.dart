import 'package:dio/dio.dart';
import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/helpers/error_handler/core/error_handler.dart';

class HttpCaller {
  static const String APPLICATION_JSON = 'application/json';
  static const String BEARER_PREFIX = 'Bearer ';

  Dio _dio;
  Dio get dio => _dio;

  static final HttpCaller _httpCaller = HttpCaller._internal();

  factory HttpCaller() {
    return _httpCaller;
  }

  HttpCaller._internal() {
    _dio = Dio();
    _dio.options.connectTimeout = 10 * 1000;
  }

  Future<dynamic> doPost(String path,
      {HttpHeaders headers, Map<String, dynamic> body}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      Response resp = await _dio.post(path,
          data: body, options: Options(headers: extractedHeaders));
      return resp.data;
    } on DioError catch (error) {
      _handleError(error);
    }
  }

  Future<dynamic> doGet(String path, {HttpHeaders headers}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      Response resp =
          await _dio.get(path, options: Options(headers: extractedHeaders));
      return resp.data;
    } on DioError catch (error) {
      _handleError(error);
    }
  }

  Future<dynamic> doDelete(String path, {HttpHeaders headers}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      await _dio.delete(path, options: Options(headers: extractedHeaders));
    } on DioError catch (error) {
      _handleError(error);
    }
  }

  Future<dynamic> doPut(String path,
      {HttpHeaders headers, Map<String, dynamic> body}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      Response resp = await _dio.put(path,
          data: body, options: Options(headers: extractedHeaders));
      return resp.data;
    } on DioError catch (error) {
      _handleError(error);
    }
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

  void _handleError(DioError error) {
    DioErrorType errorType = error.type;

    if (errorType != DioErrorType.response) {
      if (error != null) {
        if (error.type == DioErrorType.connectTimeout) {
          ErrorHandler.reportCheckedError(error, error.stackTrace);

          throw DoloresError(
              detail:
                  'Det gick inte att kontakta v??ra servrar. V??nligen f??rs??k igen eller vid ett senare tillf??lle.');
        } else if (error.type == DioErrorType.receiveTimeout) {
          ErrorHandler.reportCheckedError(error, error.stackTrace);

          throw DoloresError(
              detail:
                  'Anropet tog f??r l??ng tid p?? sig. V??nligen f??rs??k igen eller vid ett senare tillf??lle.');
        } else {
          throw error;
        }
      }
    }

    throw DoloresError.fromJson(error.response.data);
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
