import 'package:dolores/helpers/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductDialog extends StatefulWidget {
  final String title;
  final String qrCodeHintText;
  final String initQrCode;
  final String initProductName;
  final String productNameHintText;
  final String dateHintText;
  final String submitButtonText;
  final Function(String, String, String) onSubmit;
  final DateTime initDate;

  const ProductDialog({
    this.title,
    this.qrCodeHintText,
    this.initQrCode,
    this.initProductName,
    this.productNameHintText,
    this.dateHintText,
    this.submitButtonText,
    @required this.onSubmit,
    this.initDate,
  });

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final TextEditingController _dateEditingController = TextEditingController();
  final TextEditingController _newQrCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _newName;
  String _newQrCode;

  @override
  void initState() {
    super.initState();
    if (widget.initDate != null)
      _dateEditingController.text = Formatter.dateToString(widget.initDate);
    _newQrCodeController.text = widget.initQrCode;
  }

  @override
  void dispose() {
    super.dispose();
    _dateEditingController.dispose();
    _newQrCodeController.dispose();
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );
    if (picked != null && picked != widget.initDate) {
      setState(() {
        _dateEditingController.text = Formatter.dateToString(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(top: 20.0),
      titlePadding: EdgeInsets.only(top: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32))),
      scrollable: true,
      title: Text(
        widget.title ?? '',
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                            onTap: () async {
                              String barcodeScanRes =
                                  await FlutterBarcodeScanner.scanBarcode(
                                      "#FF0000",
                                      "Avbryt",
                                      true,
                                      ScanMode.DEFAULT);
                              if (barcodeScanRes != '-1') {
                                _newQrCodeController.text = barcodeScanRes;
                              }
                            },
                            child: Icon(
                              Icons.camera,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _newQrCodeController,
                            decoration: InputDecoration(
                              labelText: widget.qrCodeHintText ?? '',
                            ),
                            onSaved: (value) => _newQrCode = value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.initProductName,
                      onSaved: (value) => _newName = value,
                      decoration: new InputDecoration(
                        labelText: widget.productNameHintText ?? '',
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
                          labelText: widget.dateHintText ?? '',
                          icon: Icon(Icons.date_range,
                              color: Theme.of(context).iconTheme.color),
                        )),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Material(
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    formKey.currentState.save();
                    widget.onSubmit(
                        _newQrCode, _newName, _dateEditingController.text);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      widget.submitButtonText ?? '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
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
}
