import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/screens/base_model.dart';
import 'package:dolores/ui/screens/base_view.dart';
import 'package:flutter/material.dart';

import 'filter_model.dart';

class Filter extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function nav;
  final Function onUpdate;

  Filter({this.icon, this.title, this.nav, this.onUpdate});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool _isExpanded = false;

  getIcon(int index) {
    List<Icon> icons = [
      Icon(
        Icons.date_range_sharp,
        color: _isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      Icon(
        Icons.text_fields,
        color: _isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    ];

    return icons[index];
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FilterModel>(
      onModelReady: (model) => model.getPreferences(),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? Column(
              children: [
                Divider(
                  height: 0,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                ),
              ],
            )
          : Column(
              children: <Widget>[
                ExpansionTile(
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpanded = expanded;
                    });
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        widget.icon,
                        color: _isExpanded
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.title + ": ",
                        style: TextStyle(
                          color: _isExpanded
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      getIcon(model.currentIcon),
                    ],
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: ToggleButtons(
                            children: <Widget>[
                              Icon(Icons.date_range_sharp),
                              Icon(Icons.text_fields),
                            ],
                            onPressed: (int index) async {
                              ProductSort sort = ProductSort.NAME;
                              if (index == 0) {
                                sort = ProductSort.DATE;
                              }

                              await model.updateSorting(sort);

                              if (widget.onUpdate != null) widget.onUpdate();
                            },
                            isSelected: model.selectedStatus,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 8.0, bottom: 8.0),
                          child: IconButton(
                            icon: Icon(Icons.swap_vert),
                            onPressed: () async {
                              await model.reverseSorting();
                              if (widget.onUpdate != null) widget.onUpdate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 0),
              ],
            ),
    );
  }
}
