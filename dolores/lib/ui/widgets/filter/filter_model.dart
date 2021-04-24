import 'package:dolores/locator.dart';
import 'package:dolores/models/preference.dart';
import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/screens/base_model.dart';

class FilterModel extends BaseModel {
  final ProductService _productService = locator<ProductService>();

  List<bool> _selectedStatus = [true, false];
  List<bool> get selectedStatus => _selectedStatus;

  int _currentIcon = 0;
  int get currentIcon => _currentIcon;

  Future updateSorting(ProductSort sort) async {
    setState(ViewState.Busy);
    await _productService.updateSorting(sort);
    _currentIcon = sort.index;
    for (int buttonIndex = 0;
        buttonIndex < _selectedStatus.length;
        buttonIndex++) {
      _selectedStatus[buttonIndex] = buttonIndex == sort.index;
    }
    setState(ViewState.Idle);
  }

  Future reverseSorting() async {
    setState(ViewState.Busy);
    await _productService.reverseProducts();
    setState(ViewState.Idle);
  }

  Future getPreferences() async {
    setState(ViewState.Busy);
    Preference preference = await _productService.fetchPreference();
    _currentIcon = preference.sort.index;
    for (int buttonIndex = 0;
        buttonIndex < _selectedStatus.length;
        buttonIndex++) {
      _selectedStatus[buttonIndex] = buttonIndex == _currentIcon;
    }
    setState(ViewState.Idle);
  }
}
