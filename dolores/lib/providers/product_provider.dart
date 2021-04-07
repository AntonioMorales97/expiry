import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  List<Product> _storeProducts;
  List<Store> _stores;
  Store _currentStore;

  List<Product> get storeProducts => _storeProducts;
  List<Store> get store => _stores;
  Store get currentStore => _currentStore;

  setProduct(storeId) {
    Store store = _stores.firstWhere((store) => store.storeId == storeId);
    _storeProducts = store.products;
    _currentStore = store;
    notifyListeners();
  }

  Future<void> getStores() async {
    _stores = await dumbledoreRepository.getStore();
    _storeProducts = _stores[0].products;

    _currentStore = _stores[0];
    notifyListeners();
  }

  void removeProduct(String productId, String storeId) async {
    //TRY CATCH??
    await dumbledoreRepository.deleteProductInStore(storeId, productId);
    _storeProducts.removeWhere((product) => product.productId == productId);
  }

  void modifyProduct(String productId, String newQrCode, String newName,
      String newDate) async {
    await dumbledoreRepository.updateProductInStore(
        _currentStore.storeId, productId, newName, newQrCode, newDate);
    notifyListeners();
  }
}
