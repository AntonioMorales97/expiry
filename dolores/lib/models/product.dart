import 'package:dolores/helpers/formatter.dart';

class Product {
  final String productId;
  final String name;
  final String qrCode;
  final DateTime date;

  const Product({this.productId, this.name, this.qrCode, this.date});

  Product copyWith(
      {String productId, String name, String qrCode, DateTime date}) {
    return Product(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      qrCode: qrCode ?? this.qrCode,
      date: date ?? this.date,
    );
  }

  Product.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        name = json['name'],
        qrCode = json['qrCode'],
        date = Formatter.stringToDate(json['date']);
}
