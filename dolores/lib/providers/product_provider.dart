import 'package:dolores/models/preference.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:dolores/repositories/preference_repository.dart';
import 'package:flutter/cupertino.dart';

enum ProductSort {
  DATE,
  NAME,
}

class ProductProvider with ChangeNotifier {
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  List<Product> _storeProducts;
  List<Store> _stores;
  Store _currentStore;
  PreferenceRepository prefRepo = new PreferenceRepository();
  Preference _preference;

  List<Product> get storeProducts => _storeProducts; //TODO: Add filter
  List<Store> get store => _stores;
  Store get currentStore => _currentStore;
  Preference get preference => _preference;

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
    String prevStoreId = _currentStore.storeId;
    _currentStore = await dumbledoreRepository.updateProductInStore(
        prevStoreId, productId, newName, newQrCode, newDate);
    _storeProducts = _currentStore.products;

    int index = _stores.indexWhere((store) => store.storeId == prevStoreId);
    _stores[index] = _currentStore;
    notifyListeners();
  }

  void addProduct(String newQrCode, String newName, String newDate) async {
    Product newProd = await dumbledoreRepository.addProductToStore(
        _currentStore.storeId, newName, newQrCode, newDate);

    _currentStore.products.add(newProd);
    notifyListeners();
  }

  Future<Preference> getPreference() async {
    Preference preference = await prefRepo.getPreference();
    if (preference == null) {
      preference = Preference(sort: ProductSort.DATE);
      await prefRepo.savePreference(preference);
    }
    _preference = preference;
    return preference;
  }

  Future<void> updateSorting(ProductSort sort) async {
    ProductSort oldSort = _preference.sort;
    Preference newPref = _preference.copyWith(sort: sort);
    _preference = newPref;
    await prefRepo.savePreference(newPref);

    if (oldSort == _preference.sort) {
      _storeProducts = _storeProducts.reversed.toList();
    } else {
      _sortProduct(sort);
    }

    notifyListeners();
  }

  void _sortProduct(ProductSort productSort) {
    _storeProducts.sort((Product a, Product b) {
      if (productSort == ProductSort.DATE) {
        return a.date.compareTo(b.date);
      } else {
        return a.name.compareTo(b.name);
      }
    });
  }

  void reverseProducts() {
    _storeProducts = _storeProducts.reversed.toList();
    notifyListeners();
  }
}
