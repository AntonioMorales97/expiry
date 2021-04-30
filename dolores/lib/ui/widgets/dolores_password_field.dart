import 'package:flutter/material.dart';

class DoloresPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String initialValue;
  final Function(String value) onSaved;
  final Function(String value) validator;
  final Function(String value) onSubmitted;
  final TextInputAction textInputAction;
  final Function(String value) onChanged;
  bool obscureText;
  final String errorText;

  DoloresPasswordField({
    this.onSubmitted,
    this.errorText,
    this.initialValue,
    this.textInputAction,
    this.onChanged,
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
  bool obscureText = true;

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      obscureText: obscureText,
      decoration: new InputDecoration(
        errorText: widget.errorText,
        suffixIcon: IconButton(
          color: obscureText ? Colors.grey : null,
          icon: Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
        labelText: widget.hintText,
      ),
    );
  }
}
