import 'package:dolores/helpers/expiry_helper.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/product_dialog.dart';
import 'package:dolores/ui/widgets/product_item.dart';
import 'package:dolores/ui/widgets/scrollable_flexer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProductsScreen createState() => _ProductsScreen();
}

class _ProductsScreen extends State<ProductsScreen> {
  bool _isLoading = true;

  ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _fetch();
  }

  Future<void> _fetch() async {
    await ExpiryHelper.callFunctionErrorHandler(_productProvider.getStores());

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produkter'),
        actions: [
          _isLoading
              ? Container()
              : DropdownButton(
                  underline: Container(),
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  hint: Text(
                    _productProvider.currentStore.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onChanged: (value) {
                    _productProvider.setStore(value);
                  },
                  items: _productProvider.store
                      .map(
                        (store) => DropdownMenuItem(
                            child: Text(store.name), value: store.storeId),
                      )
                      .toList(),
                ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.add),
              onPressed: () {
                //throw Exception("TETST");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ProductDialog(
                        title: 'Lägg till',
                        qrCodeHintText: 'Skriv in eller scanna QR kod',
                        productNameHintText: 'Skriv in produktnamn',
                        dateHintText: 'Välj utgångsdatum',
                        submitButtonText: 'LÄGG TILL',
                        onSubmit: (newQrCode, newName, newDate) {
                          ExpiryHelper.callFunctionErrorHandler(_productProvider
                              .addProduct(newQrCode, newName, newDate));
                          Navigator.of(context).pop();
                        });
                  },
                );
              },
            ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<ProductProvider>(
              builder: (context, prod, _) =>
                  prod.storeProducts == null || prod.storeProducts.length <= 0
                      ? ScrollableFlexer(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: prod.storeProducts.length,
                          itemBuilder: (context, index) {
                            Product product = prod.storeProducts[index];
                            return Dismissible(
                              key: ValueKey(product.productId),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                //TODO: Dont remove if error from api.
                                ExpiryHelper.callFunctionErrorHandler(
                                    prod.removeProduct(product.productId));

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(product.name +
                                            "som går ut den: " +
                                            product.date.toString() +
                                            " har tagits bort")));
                              },
                              confirmDismiss: (_) => promptConfirm(),
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.onError,
                                  size: 20.0,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 4,
                                ),
                              ),
                              child: ProductItem(product: product),
                            );
                          },
                        ),
            ),
    );
  }

  Future<bool> promptConfirm() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(bottom: 20),
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            DoloresButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("TA BORT")),
            DoloresButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("AVBRYT"),
            ),
          ],
        );
      },
    );
  }
}
