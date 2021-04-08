import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreen createState() => _AddProductScreen();
}

class _AddProductScreen extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gå Tillbaka'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text('Lägg till en Produkt',
                        style: TextStyle(fontSize: 20, height: 2)),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        hintText: 'Qrcode',
                      ),
                      onSaved: (value) => value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ange en e-postadress';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        hintText: 'Namn',
                      ),
                      onSaved: (value) => value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ange en e-postadress';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        hintText: 'Datum',
                      ),
                      onSaved: (value) => value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ange en e-postadress';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
