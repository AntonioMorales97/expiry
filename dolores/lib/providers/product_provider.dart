import 'package:dolores/models/product.dart';
import 'package:dolores/repositories/dumbledore_repository.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  DumbledoreRepository dumbledoreRepository = DumbledoreRepository();
  List<Product> _storeProducts;

  List<Product> get storeProducts => _storeProducts;

  Future<void> getProducts(String storeId) async {
    _storeProducts = await dumbledoreRepository.getStore(storeId);
    notifyListeners();
  }
}
