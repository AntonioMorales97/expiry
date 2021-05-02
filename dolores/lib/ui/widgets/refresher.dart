import 'package:flutter/material.dart';

class Refresher extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const Refresher({@required this.onRefresh, @required this.child})
      : assert(onRefresh != null && child != null);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}
