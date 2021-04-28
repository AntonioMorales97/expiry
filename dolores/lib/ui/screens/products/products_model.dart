import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/helpers/formatter.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/models/store.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/screens/base_model.dart';

class ProductsModel extends BaseModel {
  final ProductService _productService = locator<ProductService>();
  DialogService _dialogService = locator<DialogService>();

  List<Store> _stores;
  List<Store> get stores {
    if (_stores == null) {
      _stores = _productService.stores;
    }
    return _stores;
  }

  Store _currentStore;
  Store get currentStore => _currentStore;

  DoloresError _error;
  DoloresError get error => _error;

  Future getStores() async {
    setState(ViewState.Busy);
    try {
      _stores = await _productService.getStores();
      _currentStore = _productService.currentStore;
      setState(ViewState.Idle);
    } on DoloresError catch (error) {
      _handleDoloresError(error);
    }
  }

  Future setStore(String storeId) async {
    setState(ViewState.Busy);
    _currentStore = _productService.setStore(storeId);
    setState(ViewState.Idle);
  }

  Future addProduct(String newQrCode, String newName, String newDate) async {
    ///TODO setState(ViewState.Busy); maybe not needed?
    ///TODO: We have more control now, maybe add adding state
    try {
      final updatedStore =
          await _productService.addProduct(newQrCode, newName, newDate);
      _currentStore = updatedStore;
      setState(ViewState.Idle);
    } on DoloresError catch (error) {
      _handleDoloresError(error);
    }
  }

  Future<bool> removeProduct(String productId) async {
    ///TODO more viewstates to show these or make model views of the remove product screen?
    //setState(ViewState.Busy);
    try {
      final updatedStore = await _productService.removeProduct(productId);
      _currentStore = updatedStore;
      return true;
      //setState(ViewState.Idle);
    } on DoloresError catch (error) {
      _error = error;
      return false;
      //_handleDoloresError(error);
    }
  }

  Future updateProduct(Product updatedProduct) async {
    try {
      final updatedStore = await _productService.modifyProduct(
        updatedProduct.productId,
        updatedProduct.qrCode,
        updatedProduct.name,
        Formatter.dateToString(updatedProduct.date),
      );
      _currentStore = updatedStore;
      setState(ViewState.Idle);
    } on DoloresError catch (error) {
      _handleDoloresError(error);
    }
  }

  Future showError() async {
    if (_error.status == null || _error.status != 403) {
      var res = await _dialogService.showDialog(
          title: "Felmedelande",
          description: _error.detail,
          buttonTitle: "Tillbaka");
      if (res.confirmed) {
        ///MÅSTE KOLLA MOUNTED / restricta navigation om man väntar på svar?

      }
      return;
    }

    if (_error.status == 403) {
      await _productService.forceLogout();
    }
  }

  _handleDoloresError(DoloresError error) async {
    _error = error;

    if (error.status == null || error.status != 403) {
      var res = await _dialogService.showDialog(
          title: "Felmedelande",
          description: error.detail,
          buttonTitle: "Tillbaka");
      if (res.confirmed) {
        ///MÅSTE KOLLA MOUNTED / restricta navigation om man väntar på svar?
        setState(ViewState.Busy);
      }
      return;
    }

    if (error.status == 403) {
      await _productService.forceLogout();
    }
  }
}
