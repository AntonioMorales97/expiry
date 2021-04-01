import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dolores/helpers/api_exception.dart';

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
      _handleError(error);
    }
  }

  Future<dynamic> doGet(String path, {HttpHeaders headers}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      _dio.get(path, options: Options(headers: extractedHeaders));
    } on DioError catch (error) {
      _handleError(error);
    }
  }

  Future<dynamic> doDelete(String path, {HttpHeaders headers}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      _dio.delete(path, options: Options(headers: extractedHeaders));
    } on DioError catch (error) {
      _handleError(error);
    }
  }

  Future<dynamic> doPut(String path,
      {HttpHeaders headers, Map<String, dynamic> body}) async {
    final extractedHeaders = _extractHeaders(headers);
    try {
      _dio.put(path, data: body, options: Options(headers: extractedHeaders));
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
      //TODO: Log
      print(error);
      throw Exception("Something went wrong with the communication.");
    }

    Map<String, dynamic> resp;

    try {
      resp = jsonDecode(error.response.data);
    } catch (error) {
      //TODO: Log
      print(error);
      throw Exception("Parsing JSON went wrong.");
    }

    throw ApiException.fromJson(resp);
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
