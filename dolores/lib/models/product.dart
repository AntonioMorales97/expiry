import 'package:intl/intl.dart';

class Product {
  final String productId;
  final String name;
  final String qrCode;
  final DateTime date;

  const Product({this.productId, this.name, this.qrCode, this.date});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      name: json['name'],
      qrCode: json['qrCode'],
      date: DateFormat('yyyy/M/d').parse(json['date']),
    );
  }
}
