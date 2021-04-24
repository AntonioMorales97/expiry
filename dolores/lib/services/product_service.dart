import 'dart:collection';

import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/preference.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:dolores/repositories/preference_repository.dart';

enum ProductSort {
  DATE,
  NAME,
}

class ProductService {
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  PreferenceRepository prefRepo = new PreferenceRepository();

  AuthService _authService = locator<AuthService>();

  List<Store> _stores;
  Store _currentStore;

  Preference _preference;
  DateTime _cachedTime;

  UnmodifiableListView<Product> get storeProducts {
    return UnmodifiableListView(_currentStore.products);
  }

  UnmodifiableListView<Store> get stores => UnmodifiableListView(_stores);

  Store get currentStore => _currentStore.copyWith();
  Preference get preference => _preference.copyWith();

  Store setStore(storeId) {
    Store store = _stores.firstWhere((store) => store.storeId == storeId);
    _currentStore = store;
    return currentStore;
  }

  Future<List<Store>> getStores({refresh: false}) async {
    DateTime newDate = DateTime.now();
    if (refresh ||
        (_cachedTime == null ||
            _cachedTime.difference(newDate).inMinutes > 20)) {
      //TODO KANSKE WRAPER FÖR API CALL SOM HANTERAR ERRORS ?

      _stores = await dumbledoreRepository.getStore();
      _currentStore = _stores[0];

      if (_preference == null) {
        await fetchPreference();
      }

      _sortProduct(_preference.sort);
      if (_preference.reverse) await _reverseProducts();
      _cachedTime = newDate;

      return stores;
    }
  }

  //TODO: BROKEN
  Future<Store> removeProduct(String productId) async {
    int idx = _currentStore.products
        .lastIndexWhere((product) => product.productId == productId);
    if (idx == -1) {
      return currentStore;
    }
    Product product = _currentStore.products[idx];
    try {
      _currentStore.products.removeAt(idx);
      await dumbledoreRepository.deleteProductInStore(
          _currentStore.storeId, productId);
      return currentStore;
    } catch (error) {
      _currentStore.products.insert(idx, product);
      if (error is DoloresError) {
        //_error = error;
      } else {
        throw error;
      }
    } finally {}
  }

  Future<Store> modifyProduct(String productId, String newQrCode,
      String newName, String newDate) async {
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
    return currentStore;
  }

  //TODO: Insert right
  Future<Store> addProduct(
      String newQrCode, String newName, String newDate) async {
    Product newProd = await dumbledoreRepository.addProductToStore(
        _currentStore.storeId, newName, newQrCode, newDate);

    _currentStore.products.add(newProd);
    return currentStore;
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
