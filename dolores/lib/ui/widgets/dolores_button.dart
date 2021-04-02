import 'package:flutter/material.dart';

class DoloresButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  DoloresButton({@required this.text, this.onPressed});
  @override
  _DoloresButton createState() => _DoloresButton();
}

class _DoloresButton extends State<DoloresButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6.0,
            offset: Offset(0, 6),
            spreadRadius: -3.0,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8.0,
        ),
        onPressed: widget.onPressed,
        child: Text(widget.text),
      ),
    );
  }
}
