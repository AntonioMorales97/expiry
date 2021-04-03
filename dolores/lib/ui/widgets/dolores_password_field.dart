import 'package:flutter/material.dart';

class DoloresPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String value) onSaved;
  final Function(String value) validator;
  bool obscureText;
  final String errorText;

  DoloresPasswordField({
    this.errorText,
    this.controller,
    @required this.hintText,
    this.onSaved,
    this.validator,
    this.obscureText = true,
  });

  @override
  _DoloresPasswordFieldState createState() => _DoloresPasswordFieldState();
}

class _DoloresPasswordFieldState extends State<DoloresPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      decoration: new InputDecoration(
        errorText: widget.errorText,
        suffixIcon: IconButton(
          color: widget.obscureText ? Colors.grey : Colors.blueAccent,
          icon: Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              widget.obscureText = !widget.obscureText;
            });
          },
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black54, width: 1.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        hintText: widget.hintText,
      ),
    );
  }
}
