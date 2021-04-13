import 'dart:collection';

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
  PreferenceRepository prefRepo = new PreferenceRepository();

  List<Store> _stores;
  Store _currentStore;

  Preference _preference;
  DateTime _cachedTime;

  UnmodifiableListView<Product> get storeProducts {
    return UnmodifiableListView(_currentStore.products);
  }

  UnmodifiableListView<Store> get store => UnmodifiableListView(_stores);

  Store get currentStore => _currentStore.copyWith();
  Preference get preference => _preference.copyWith();

  ProductProvider() {
    fetchPreference();
  }

  setStore(storeId) {
    Store store = _stores.firstWhere((store) => store.storeId == storeId);
    _currentStore = store;
    notifyListeners();
  }

  Future<void> getStores({refresh: false}) async {
    DateTime newDate = DateTime.now();
    if (refresh ||
        (_cachedTime == null ||
            _cachedTime.difference(newDate).inMinutes > 20)) {
      _stores = await dumbledoreRepository.getStore();
      _cachedTime = newDate;
    }
    _currentStore = _stores[0];

    if (_preference != null) {
      //this should never be null
      _sortProduct(_preference.sort);
      if (_preference.reverse) await _reverseProducts();
    }
    notifyListeners();
  }

  void removeProduct(String productId) async {
    await dumbledoreRepository.deleteProductInStore(
        _currentStore.storeId, productId);
    _currentStore.products
        .removeWhere((product) => product.productId == productId);
  }

  void modifyProduct(String productId, String newQrCode, String newName,
      String newDate) async {
    //TODO: Maybe enough with HTTP 200 and update product accordingly
    _currentStore = await dumbledoreRepository.updateProductInStore(
      _currentStore.storeId,
      productId,
      newName,
      newQrCode,
      newDate,
    );
    int index =
        _stores.indexWhere((store) => store.storeId == _currentStore.storeId);
    _stores[index] = _currentStore;
    notifyListeners();
  }

  void addProduct(String newQrCode, String newName, String newDate) async {
    Product newProd = await dumbledoreRepository.addProductToStore(
        _currentStore.storeId, newName, newQrCode, newDate);

    _currentStore.products.add(newProd);
    notifyListeners();
  }

  Future<Preference> fetchPreference() async {
    Preference preference = await prefRepo.getPreference();
    if (preference == null) {
      preference = Preference(sort: ProductSort.DATE);
      await prefRepo.savePreference(preference);
    }
    _preference = preference;
    return preference.copyWith();
  }

  Future<void> updateSorting(ProductSort sort) async {
    ProductSort oldSort = _preference.sort;
    Preference newPref = _preference.copyWith(sort: sort);
    _preference = newPref;
    await prefRepo.savePreference(newPref);

    if (oldSort == _preference.sort) {
      final reversed = _currentStore.products.reversed.toList();
      _currentStore = _currentStore.copyWith(products: reversed);
      _preference = _preference.copyWith(reverse: !_preference.reverse);
    } else {
      _sortProduct(sort);
    }

    notifyListeners();
  }

  void _sortProduct(ProductSort productSort) {
    _currentStore.products.sort((Product a, Product b) {
      if (productSort == ProductSort.DATE) {
        return a.date.compareTo(b.date);
      } else {
        return a.name.compareTo(b.name);
      }
    });
  }

  Future<void> reverseProducts() async {
    final reversed = _currentStore.products.reversed.toList();
    _currentStore = _currentStore.copyWith(products: reversed);
    _preference = _preference.copyWith(reverse: !_preference.reverse);
    await prefRepo.savePreference(_preference);
    notifyListeners();
  }

  _reverseProducts() async {
    final reversed = _currentStore.products.reversed.toList();
    _currentStore = _currentStore.copyWith(products: reversed);
    await prefRepo.savePreference(_preference);
  }

  clearStates() {
    _currentStore = null;
    _preference = null;
    _cachedTime = null;
    _stores = null;
  }
}
