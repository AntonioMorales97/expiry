import 'package:flutter/material.dart';

class DoloresButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final bool isLoading;

  const DoloresButton(
      {@required this.child, this.onPressed, this.isLoading = false});

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
        onPressed: onPressed,
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                ),
              )
            : child,
      ),
    );
  }
}
