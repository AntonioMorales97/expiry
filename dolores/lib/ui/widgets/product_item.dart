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
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10.0),
          height: 60,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Formatter.dateToString(date),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 260),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    //TODO onPress toggle product options.
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
        ),
      ],
    );
  }
}