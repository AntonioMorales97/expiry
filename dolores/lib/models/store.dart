import 'package:dolores/models/product.dart';

class Store {
  final String storeId;
  final String name;
  final List<Product> products;

  const Store({this.storeId, this.name, this.products});

  Store copyWith({String storeId, String name, List<Product> products}) {
    return Store(
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      products: products ?? this.products,
    );
  }

  Store.fromJson(Map<String, dynamic> json)
      : storeId = json['id'],
        name = json['name'],
        products = List<Product>.from(
          json['products'].map(
            (product) => Product.fromJson(product),
          ),
        );
}
