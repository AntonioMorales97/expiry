import 'package:dolores/helpers/formatter.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/providers/product_provider.dart';
import 'package:flutter/material.dart';
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
          height: 60,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline6,
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
              Padding(
                padding: const EdgeInsets.only(left: 260),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductScreenDialog(product: product);
                        });
                  },
                ),
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

class ProductScreenDialog extends StatefulWidget {
  const ProductScreenDialog({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductScreenDialogState createState() => _ProductScreenDialogState();
}

class _ProductScreenDialogState extends State<ProductScreenDialog> {
  final formKey = GlobalKey<FormState>();
  String _newName;
  String _newQrCode;

  final TextEditingController _dateEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dateEditingController.text = Formatter.dateToString(widget.product.date);
  }

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductProvider>(context, listen: false);
    return AlertDialog(
      buttonPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(top: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32))),
      scrollable: true,
      title: Text(
        'Ändra',
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: 310, //TODO might have to change to lower.

        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) => _newQrCode = value,
                      initialValue: widget.product.qrCode,
                      decoration: new InputDecoration(
                        icon: Icon(Icons.qr_code,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onSaved: (value) => _newName = value,
                      initialValue: widget.product.name,
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.label,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        readOnly: true,
                        controller: _dateEditingController,
                        onTap: () => _showDatePicker(),
                        decoration: new InputDecoration(
                          icon: Icon(Icons.date_range,
                              color: Theme.of(context).iconTheme.color),
                        )),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  final form = formKey.currentState;
                  form.save();
                  prod.modifyProduct(widget.product.productId, _newQrCode,
                      _newName, _dateEditingController.text);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0)),
                  ),
                  child: Text(
                    "Rate Product",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [],
    );
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.product.date,
      firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );
    if (picked != null && picked != widget.product.date) {
      setState(() {
        _dateEditingController.text = Formatter.dateToString(picked);
      });
    }
  }
}
