import 'package:dolores/models/store.dart';
import 'package:dolores/repositories/http_caller.dart';

import 'filtch_repository.dart';

class DumbledoreRepository {
  static const String baseUrl = 'http://10.0.2.2:9091';
  static const String changePasswordUrl = '/user/change-password';
  static const String storeBaseUrl = '/store';
  static const String productsUrl = "/products";

  final HttpCaller _httpCaller = HttpCaller();
  final FiltchRepository filtchRepository = FiltchRepository();

  String _token;

  Future _getToken() async {
    _token = await filtchRepository.getToken();
  }

  _checkToken() async {
    if (_token == null) {
      await _getToken();
    }
  }

  /**
   * Måste kanske byta return från dumbledore här.
   */
  Future<dynamic> changePassword(
      String email, String password, String rePassword) async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    dynamic resp = await _httpCaller
        .doPut(baseUrl + changePasswordUrl, headers: httpHeaders, body: {
      'email': email,
      'password': password,
      'rePassword': rePassword,
    });

    return resp;
  }

  /**
   * STORE REQUESTS BELOW
   */
  Future<List<Store>> getStore() async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    final List<dynamic> resp = await _httpCaller
        .doGet(baseUrl + storeBaseUrl + productsUrl, headers: httpHeaders);
    List<Store> stores = resp.map((store) => Store.fromJson(store)).toList();

    return stores;
  }

  Future<void> deleteProductInStore(String storeId, String productsId) async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    await _httpCaller.doDelete(
        baseUrl + storeBaseUrl + "/" + storeId + productsUrl + "/" + productsId,
        headers: httpHeaders);
  }

  Future<dynamic> addProductToStore(
      String storeId, String name, String qrCode, String date) async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    dynamic response = await _httpCaller.doPost(
        baseUrl + storeBaseUrl + storeId + productsUrl,
        headers: httpHeaders,
        body: {
          'name': name,
          'qrCode': qrCode,
          'date': date,
        });
    return response;
  }

  Future<void> updateProductInStore(String storeId, String productsId,
      String name, String qrCode, String date) async {
    await _checkToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    await _httpCaller.doPut(
        baseUrl + storeBaseUrl + storeId + productsUrl + '/' + productsId,
        headers: httpHeaders,
        body: {
          'name': name,
          'qrCode': qrCode,
          'date': date,
        });
  }
}
