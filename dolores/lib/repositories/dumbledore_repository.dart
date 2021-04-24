import 'package:dolores/environment.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/repositories/http_caller.dart';

import 'filtch_repository.dart';

class DumbledoreRepository {
  final String baseUrl = env.dumbledoreBaseUrl;
  static const String changePasswordUrl = '/user/change-password';
  static const String storeBaseUrl = '/store';
  static const String productsUrl = '/products';

  final HttpCaller _httpCaller = HttpCaller();
  final FiltchRepository filtchRepository = FiltchRepository();

  static final DumbledoreRepository _dumbledoreRepository =
      DumbledoreRepository._internal();

  factory DumbledoreRepository() {
    return _dumbledoreRepository;
  }

  DumbledoreRepository._internal();

  String _token;

  Future _getToken() async {
    _token = await filtchRepository.getToken();
  }

  //TODO: Måste kanske byta return från dumbledore här.
  Future<dynamic> changePassword(String email, String oldPassword,
      String password, String rePassword) async {
    await _getToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    await _httpCaller
        .doPut(baseUrl + changePasswordUrl, headers: httpHeaders, body: {
      'email': email,
      'oldPassword': oldPassword,
      'password': password,
      'rePassword': rePassword,
    });
  }

  Future<dynamic> sendErrorLog(Map<String, dynamic> json) async {
    final resp =
        await _httpCaller.doPost(baseUrl + '/log/error-log', body: json);
    return resp;
  }

  Future<List<Store>> getStore() async {
    await _getToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    final List<dynamic> resp = await _httpCaller
        .doGet(baseUrl + storeBaseUrl + productsUrl, headers: httpHeaders);
    List<Store> stores = resp.map((store) => Store.fromJson(store)).toList();

    return stores;
  }

  Future<void> deleteProductInStore(String storeId, String productsId) async {
    await _getToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    await _httpCaller.doDelete(
        baseUrl + storeBaseUrl + "/" + storeId + productsUrl + "/" + productsId,
        headers: httpHeaders);
  }

  Future<Product> addProductToStore(
      String storeId, String name, String qrCode, String date) async {
    await _getToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;
    String url = baseUrl + storeBaseUrl + "/" + storeId + productsUrl;
    final Map<String, dynamic> resp =
        await _httpCaller.doPost(url, headers: httpHeaders, body: {
      'name': name,
      'qrCode': qrCode,
      'date': date,
    });
    Product product = Product.fromJson(resp);
    return product;
  }

  Future<Store> updateProductInStore(String storeId, String productId,
      String name, String qrCode, String date) async {
    await _getToken();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.authorizationToken = _token;

    final Map<String, dynamic> resp = await _httpCaller.doPut(
        baseUrl + storeBaseUrl + '/' + storeId + productsUrl,
        headers: httpHeaders,
        body: {
          'productId': productId,
          'name': name,
          'qrCode': qrCode,
          'date': date,
        });
    Store stores = Store.fromJson(resp);

    return stores;
  }
}
