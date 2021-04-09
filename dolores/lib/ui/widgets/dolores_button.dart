import 'package:flutter/material.dart';

class DoloresButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;

  DoloresButton({@required this.child, this.onPressed});
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
            blurRadius: 4.0,
            offset: Offset(0, 6),
            spreadRadius: -8.0,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
