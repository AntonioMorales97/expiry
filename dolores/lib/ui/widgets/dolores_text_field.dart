import 'package:flutter/material.dart';

class DoloresTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String value) onSaved;
  final Function(String value) validator;
  final Function(String value) onSubmitted;
  final TextInputAction textInputAction;

  const DoloresTextField({
    this.onSubmitted,
    this.textEditingController,
    this.hintText,
    this.onSaved,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      controller: textEditingController,
      onSaved: onSaved,
      validator: validator,
      textInputAction: textInputAction,
      decoration: new InputDecoration(
        hintText: hintText ?? '',
      ),
    );
  }
}
