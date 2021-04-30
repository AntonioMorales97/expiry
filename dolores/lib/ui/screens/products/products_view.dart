import 'package:dolores/helpers/formatter.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/services/dialog_service.dart';
import 'package:dolores/ui/screens/products/bloc/products.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/product_dialog.dart';
import 'package:dolores/ui/widgets/scrollable_flexer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
                        child: _ProductDialogManager(
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
                            confirmDismiss: (_) => promptConfirm(
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
                            child: ProductItem1(
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

  Future<bool> promptConfirm(
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
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
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

class ProductItem1 extends StatelessWidget {
  final Product product;
  final Function(String newQrCode, String newName, String newDate) onSubmit;

  ProductItem1({@required this.product, @required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final productsBloc = BlocProvider.of<ProductsBloc>(context, listen: false);
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
                      overflow: TextOverflow.ellipsis,
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
                  // prod.modifyProduct(product.productId, barcodeScanRes,
                  //     product.name, Formatter.dateToString(product.date));
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
                    builder: (BuildContext context) =>
                        BlocProvider<ProductsBloc>.value(
                      value: productsBloc,
                      child: _ProductDialogManager(
                        product: product,
                        onSubmit: onSubmit,
                        title: 'Ändra produkt',
                        submitButtonText: 'ÄNDRA',
                      ),
                    ),
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

class _ProductDialogManager extends StatefulWidget {
  final Product product;
  final onSubmit;
  final String title;
  final String submitButtonText;

  final String qrCodeHintText;
  final String productNameHintText;
  final String dateHintText;

  _ProductDialogManager({
    this.product,
    @required this.onSubmit,
    @required this.title,
    @required this.submitButtonText,
    this.qrCodeHintText,
    this.productNameHintText,
    this.dateHintText,
  });

  @override
  _ProductDialogManagerState createState() => _ProductDialogManagerState();
}

class _ProductDialogManagerState extends State<_ProductDialogManager> {
  String _newName;
  String _newQrCode;
  DateTime _newDate;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _newName = widget.product.name;
      _newQrCode = widget.product.qrCode;
      _newDate = widget.product.date;
    }
  }

  void setFormData(newQrCode, newName, newDate) {
    _newName = newName;
    _newQrCode = newQrCode;
    _newDate = Formatter.stringToDate(newDate);
  }

  bool isLoading(ProductsState state) {
    return state.updatingStatus == Status.Loading ||
        state.addingStatus == Status.Loading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state.updatingStatus == Status.Success ||
            state.addingStatus == Status.Success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return ProductDialog(
          isLoading: isLoading(state),
          initQrCode: _newQrCode,
          initProductName: _newName,
          initDate: _newDate,
          qrCodeHintText: widget.qrCodeHintText,
          productNameHintText: widget.productNameHintText,
          dateHintText: widget.dateHintText,
          title: widget.title,
          submitButtonText: widget.submitButtonText,
          onSubmit: (newQrCode, newName, newDate) {
            setFormData(newQrCode, newName, newDate);
            widget.onSubmit(newQrCode, newName, newDate);
          },
        );
      },
    );
  }
}
