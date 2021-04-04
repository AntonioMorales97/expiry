import 'package:dolores/models/product.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/app_drawer.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
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
    await prod.getProducts("6060a265834e373445677877");
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final prod = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: prod.getProducts("6060a265834e373445677877"),
        builder: (context, snap) =>
            snap.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : prod.storeProducts == null || prod.storeProducts.length <= 0
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
                              //TODO remove item from backend.

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(product.name +
                                          "som går ut den: " +
                                          product.date +
                                          " har tagits bort")));
                            },
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
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name),
                                  Text(product.date),
                                  Divider(
                                    height: 1.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
