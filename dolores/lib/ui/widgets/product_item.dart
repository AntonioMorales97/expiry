import 'package:dolores/helpers/formatter.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductProvider>(context, listen: false);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(minHeight: 60),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis, //TODO rolling text.
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      Formatter.dateToString(product.date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.camera,
                ),
                onPressed: () async {
                  String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                          "#FF0000", "Avbryt", true, ScanMode.DEFAULT);
                  if (barcodeScanRes == '-1') {
                    barcodeScanRes = product.qrCode;
                  }
                  prod.modifyProduct(product.productId, barcodeScanRes,
                      product.name, Formatter.dateToString(product.date));
                  print(barcodeScanRes);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ProductDialog(
                        initQrCode: product.qrCode,
                        initProductName: product.name,
                        initDate: product.date,
                        title: 'Ändra produkt',
                        submitButtonText: 'ÄNDRA',
                        onSubmit: (newQrCode, newName, newDate) {
                          prod.modifyProduct(
                              product.productId, newQrCode, newName, newDate);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
        ),
      ],
    );
  }
}
