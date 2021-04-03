import 'package:flutter/material.dart';

class DoloresTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String value) onSaved;
  final Function(String value) validator;

  const DoloresTextField(
      {this.textEditingController,
      this.hintText,
      this.onSaved,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onSaved: onSaved,
      validator: validator,
      decoration: new InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        hintText: hintText ?? '',
      ),
    );
  }
}
