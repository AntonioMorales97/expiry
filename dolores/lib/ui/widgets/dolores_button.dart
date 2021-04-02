import 'package:flutter/material.dart';

class DoloresButton extends StatelessWidget {
  const DoloresButton({
    Key key,
  }) : super(key: key);

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
        onPressed: () {},
        child: Text('Login'),
      ),
    );
  }
}
