import 'package:flutter/material.dart';

class ScrollableFlexer extends StatelessWidget {
  final Widget child;

  const ScrollableFlexer({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
