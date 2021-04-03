class Product {
  final String productId;
  final String name;
  final String qrCode;
  final String date;

  const Product({this.productId, this.name, this.qrCode, this.date});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      productId: parsedJson['productId'],
      name: parsedJson['name'],
      qrCode: parsedJson['qrCode'],
      date: parsedJson['date'],
    );
  }
}
