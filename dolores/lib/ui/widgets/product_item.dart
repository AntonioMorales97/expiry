import 'package:dolores/helpers/formatter.dart';
import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/models/product.dart';
import 'package:dolores/ui/screens/products/bloc/products.dart';
import 'package:dolores/ui/widgets/dialog/bloc/dialog.dart';
import 'package:dolores/ui/widgets/dialog/dialog_manager.dart';
import 'package:dolores/ui/widgets/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function(String newQrCode, String newName, String newDate) onSubmit;
  final ProductsBloc productsBloc;

  ProductItem({
    @required this.product,
    @required this.onSubmit,
    @required this.productsBloc,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icons.settings,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        BlocProvider<ProductsBloc>.value(
                      value: productsBloc,
                      child: ProductDialogManager(
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

class ProductDialogManager extends StatefulWidget {
  final Product product;
  final onSubmit;
  final String title;
  final String submitButtonText;

  final String qrCodeHintText;
  final String productNameHintText;
  final String dateHintText;

  ProductDialogManager({
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

class _ProductDialogManagerState extends State<ProductDialogManager> {
  String _newName;
  String _newQrCode;
  DateTime _newDate;

  DialogBloc _dialogBloc;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _newName = widget.product.name;
      _newQrCode = widget.product.qrCode;
      _newDate = widget.product.date;
    }
    _dialogBloc = DialogBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _dialogBloc.close();
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
          _dialogBloc.add(Hide());
        } else if (state.updatingStatus == Status.Loading ||
            state.addingStatus == Status.Loading) {
          _dialogBloc.add(Load());
        } else if (state.updatingStatus == Status.Fail ||
            state.addingStatus == Status.Fail) {
          _dialogBloc.add(Show());
        }
      },
      builder: (context, state) {
        return BlocProvider.value(
          value: _dialogBloc,
          child: DialogManager(
            child: ProductDialog(
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
            ),
          ),
        );
      },
    );
  }
}
