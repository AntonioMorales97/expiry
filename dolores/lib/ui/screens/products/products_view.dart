import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/ui/screens/products/bloc/products.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/product_item.dart';
import 'package:dolores/ui/widgets/scrollable_flexer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsView extends StatelessWidget {
  final _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    final productsBloc = BlocProvider.of<ProductsBloc>(context, listen: false);
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state.error != null) {
          _dialogService.showDialog(
              title: "Felmedelande",
              description: state.error.detail,
              buttonTitle: "Tillbaka");
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Produkter'),
          actions: [
            state.fetchingStatus == Status.Loading || state.currentStore == null
                ? Container()
                : DropdownButton(
                    underline: Container(),
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    hint: Text(
                      state.currentStore.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onChanged: (value) {
                      productsBloc.add(ChangeStore(value));
                    },
                    items: state.stores //TODO: Null check here
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
          onFilterUpdate: () => productsBloc.add(FetchProducts()),
        ),
        floatingActionButton: state.fetchingStatus == Status.Loading
            ? null
            : FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider<ProductsBloc>.value(
                        value: productsBloc,
                        child: ProductDialogManager(
                            title: 'Lägg till',
                            qrCodeHintText: 'Skriv in eller scanna QR kod',
                            productNameHintText: 'Skriv in produktnamn',
                            dateHintText: 'Välj utgångsdatum',
                            submitButtonText: 'LÄGG TILL',
                            onSubmit: (newQrCode, newName, newDate) {
                              productsBloc.add(
                                AddProduct(
                                    newQrCode: newQrCode,
                                    newName: newName,
                                    newDate: newDate),
                              );
                            }),
                      );
                    },
                  );
                },
              ),
        body: state.fetchingStatus == Status.Loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: state.currentStore == null ||
                        state.currentStore.products == null ||
                        state.currentStore.products.length <= 0
                    ? ScrollableFlexer(
                        child: Center(
                          child: Text('Empty'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.currentStore.products.length,
                        itemBuilder: (context, index) {
                          Product product = state.currentStore.products[index];
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
                            confirmDismiss: (_) => promptDeleteConfirm(
                                context, productsBloc, product.productId),
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
                              productsBloc: productsBloc,
                              product: product,
                              onSubmit: (String newQrCode, String newName,
                                      String newDate) =>
                                  productsBloc.add(
                                UpdateProduct(
                                    productId: product.productId,
                                    newQrCode: newQrCode,
                                    newDate: newDate,
                                    newName: newName),
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Future<bool> promptDeleteConfirm(
    BuildContext context,
    ProductsBloc productsBloc,
    String productId,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => BlocProvider<ProductsBloc>.value(
        value: productsBloc,
        child: BlocConsumer<ProductsBloc, ProductsState>(
          listener: (context, state) {
            if (state.removeStatus == Status.Success) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return AlertDialog(
              actionsPadding: EdgeInsets.only(bottom: 20),
              title: const Text("Bekräfta"),
              content: const Text(
                  "Är du säker på att du vill ta bort denna produkt?"),
              actions: <Widget>[
                DoloresButton(
                  onPressed: () async {
                    productsBloc.add(RemoveProduct(productId: productId));
                  },
                  child: const Text("TA BORT"),
                ),
                DoloresButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("AVBRYT"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
