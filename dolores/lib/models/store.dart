import 'package:dolores/models/product.dart';

class Store {
  final String storeId;
  final String name;
  final List<Product> products;

  const Store({this.storeId, this.name, this.products});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['id'],
      name: json['name'],
      products: List<Product>.from(
          json['products'].map((product) => Product.fromJson(product))),
    );
  }
}
