import 'package:dolores/models/product.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
import 'package:dolores/ui/widgets/product_item.dart';
import 'package:dolores/ui/widgets/scrollable_flexer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreen createState() => _ProductsScreen();
}

class _ProductsScreen extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    setProducts();
  }

  void setProducts() async {
    final prod = Provider.of<ProductProvider>(context, listen: false);

    await prod.getStores();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final prod = Provider.of<ProductProvider>(context, listen: false);

    return FutureBuilder(
        future: prod.getStores(),
        builder: (context, snap) => snap.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Produkter'),
                  actions: [
                    Row(
                      children: [
                        DropdownButton(
                          hint: Text(prod.currentStore.name),
                          onChanged: (value) {
                            prod.setProduct(value);
                          },
                          items: prod.store
                              .map((store) => DropdownMenuItem(
                                  child: Text(store.name),
                                  value: store.storeId))
                              .toList(),
                        ),
                      ],
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: Text('Logout'),
                  onPressed: () => auth.logout(),
                ),
                drawer: AppDrawer(),
                body: Consumer<ProductProvider>(
                  builder: (context, prod, _) => prod.storeProducts == null ||
                          prod.storeProducts.length <= 0
                      ? ScrollableFlexer(
                          child: Center(
                          child: Text('Empty'),
                        ))
                      : ListView.builder(
                          itemCount: prod.storeProducts.length,
                          itemBuilder: (context, index) {
                            Product product = prod.storeProducts[index];
                            return Dismissible(
                              key: ValueKey(product.productId),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                //TODO Dont remove if error from api.
                                prod.removeProduct(product.productId,
                                    prod.currentStore.storeId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(product.name +
                                            "som går ut den: " +
                                            product.date.toString() +
                                            " har tagits bort")));
                              },
                              confirmDismiss: (_) => promptConfirm(),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 4,
                                ),
                              ),
                              //TODO styling :-) + wheel
                              child: ProductItem(product: product),
                            );
                          },
                        ),
                ),
              ));
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
