import 'package:dolores/helpers/formatter.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final DateTime date;

  const ProductItem({
    this.name,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Text(
            Formatter.dateToString(date),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
