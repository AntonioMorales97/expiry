import 'package:flutter/material.dart';

class DoloresPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String value) onSaved;
  final Function(String value) validator;
  final Function(String value) onSubmitted;
  final TextInputAction textInputAction;
  bool obscureText;
  final String errorText;

  DoloresPasswordField({
    this.onSubmitted,
    this.errorText,
    this.textInputAction,
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
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      decoration: new InputDecoration(
        errorText: widget.errorText,
        suffixIcon: IconButton(
          color: widget.obscureText ? Colors.grey : null,
          icon: Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              widget.obscureText = !widget.obscureText;
            });
          },
        ),
        hintText: widget.hintText,
      ),
    );
  }
}
