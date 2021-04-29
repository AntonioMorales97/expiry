import 'package:dolores/models/product.dart';
import 'package:dolores/ui/screens/base_model.dart';
import 'package:dolores/ui/screens/base_view.dart';
import 'package:dolores/ui/screens/products/products_model.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/product_dialog.dart';
import 'package:dolores/ui/widgets/product_item.dart';
import 'package:dolores/ui/widgets/scrollable_flexer.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ProductsModel>(
      onModelReady: (model) => model.getStores(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Produkter'),
          actions: [
            model.state == ViewState.Busy || model.currentStore == null
                ? Container()
                : DropdownButton(
                    underline: Container(),
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    hint: Text(
                      model.currentStore.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onChanged: (value) {
                      model.setStore(value);
                    },
                    items: model.stores
                        .map(
                          (store) => DropdownMenuItem(
                              child: Text(store.name), value: store.storeId),
                        )
                        .toList(),
                  ),
          ],
        ),
        drawer: AppDrawer(
          active: '/',
          onFilterUpdate: () => model.getStores(),
        ),
        floatingActionButton: model.state == ViewState.Busy
            ? null
            : FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add),
                onPressed: () {
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
                            model.addProduct(newQrCode, newName, newDate);
                            Navigator.of(context).pop();
                          });
                    },
                  );
                },
              ),
        body: model.state == ViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: model.currentStore.products == null ||
                        model.currentStore.products.length <= 0
                    ? ScrollableFlexer(
                        child: Center(
                          child: Text('Empty'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: model.currentStore.products.length,
                        itemBuilder: (context, index) {
                          Product product = model.currentStore.products[index];
                          return Dismissible(
                            key: ValueKey(product.productId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              //TODO: Perhaps make a listener of this
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(product.name +
                                          "som går ut den: " +
                                          product.date.toString() +
                                          " har tagits bort")));
                            },
                            confirmDismiss: (_) => promptConfirm(
                                context, model, product.productId),
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
                            child: ProductItem(
                                product: product,
                                onSubmit: (Product updatedProduct) =>
                                    model.updateProduct(updatedProduct)),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Future<bool> promptConfirm(BuildContext context, model, productId) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(bottom: 20),
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            DoloresButton(
                onPressed: () async {
                  bool boolean = await model.removeProduct(productId);
                  if (boolean) {
                    Navigator.of(context).pop(true);
                  } else {
                    ///TODO CHECK MOUNTED
                    Navigator.of(context).pop(false);
                    model.showError();
                  }
                },
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
