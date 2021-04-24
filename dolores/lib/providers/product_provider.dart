import 'dart:collection';

import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/models/preference.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/providers/auth_provider.dart';
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

  AuthProvider _authProvider;

  List<Store> _stores;
  Store _currentStore;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DoloresError _error;
  DoloresError get error => _error;

  resetErrors() {
    _error = null;
  }

  Preference _preference;
  DateTime _cachedTime;

  UnmodifiableListView<Product> get storeProducts {
    return UnmodifiableListView(_currentStore.products);
  }

  UnmodifiableListView<Store> get store => UnmodifiableListView(_stores);

  Store get currentStore => _currentStore.copyWith();
  Preference get preference => _preference.copyWith();

  ProductProvider(this._authProvider);

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
      //TODO KANSKE WRAPER FÖR API CALL SOM HANTERAR ERRORS ?
      try {
        _stores = await dumbledoreRepository.getStore();
        _currentStore = _stores[0];

        if (_preference == null) {
          await fetchPreference();
        }

        _sortProduct(_preference.sort);
        if (_preference.reverse) await _reverseProducts();
        _isLoading = false;
        _cachedTime = newDate;
        notifyListeners();
      } on DoloresError catch (error) {
        _handleDoloresError(error);
      }
    }
  }

  Future<void> removeProduct(String productId) async {
    int idx = _currentStore.products
        .lastIndexWhere((product) => product.productId == productId);
    if (idx == -1) {
      notifyListeners();
    }
    Product product = _currentStore.products[idx];
    try {
      _currentStore.products.removeAt(idx);
      notifyListeners();
      await dumbledoreRepository.deleteProductInStore(
          _currentStore.storeId, productId);
    } catch (error) {
      _currentStore.products.insert(idx, product);
      if (error is DoloresError) {
        _error = error;
      } else {
        throw error;
      }
    } finally {
      notifyListeners();
    }
  }

  void modifyProduct(String productId, String newQrCode, String newName,
      String newDate) async {
    try {
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
    } on DoloresError catch (error) {
      _error = error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProduct(
      String newQrCode, String newName, String newDate) async {
    try {
      Product newProd = await dumbledoreRepository.addProductToStore(
          _currentStore.storeId, newName, newQrCode, newDate);

      _currentStore.products.add(newProd);
    } on DoloresError catch (error) {
      _error = error;
    } finally {
      notifyListeners();
    }
  }

  Future<Preference> fetchPreference() async {
    if (_preference != null) {
      return _preference.copyWith();
    }
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

  _handleDoloresError(DoloresError error) async {
    _error = error;

    if (error.status == null || error.status != 403) {
      notifyListeners();
      return;
    }

    if (error.status == 403) {
      _authProvider.forceLogout();
    }
  }

  clearStates() {
    _currentStore = null;
    _preference = null;
    _cachedTime = null;
    _stores = null;
    _isLoading = true;
  }
}
