import 'package:dolores/models/product.dart';
import 'package:dolores/providers/auth_provider.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:dolores/ui/widgets/dolores_button.dart';
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
    await prod.getProducts("6066413a362bd4211dd66fa4");
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final prod = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          if (prod.storeProducts != null)
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: prod.storeProducts.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = prod.storeProducts[index];
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      //TODO remove item from backend.

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(product.name +
                              "som går ut den: " +
                              product.date +
                              " har tagits bort")));
                    },
                    background: Container(color: Colors.red),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(product.name), Text(product.date)]));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          Center(
            child: DoloresButton(
              onPressed: auth.logout,
              text: 'Logout',
            ),
          ),
        ],
      ),
    );
  }
}
