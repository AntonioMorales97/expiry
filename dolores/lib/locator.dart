import 'package:dolores/services/auth_service.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/widgets/filter/filter_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => DialogService());

  locator.registerFactory(() => FilterModel());
}
