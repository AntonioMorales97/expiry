import 'package:flutter/material.dart';

class DoloresCheckbox extends StatefulWidget {
  final String title;
  final Function(bool) onChange;
  bool value;
  final double padding;

  DoloresCheckbox(
      {this.title, this.onChange, this.padding, @required this.value});

  @override
  _DoloresCheckboxState createState() => _DoloresCheckboxState();
}

class _DoloresCheckboxState extends State<DoloresCheckbox> {
  void _toggle(bool check) {
    setState(() {
      widget.value = check;
    });
    if (widget.onChange != null) widget.onChange(check);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Checkbox(
            value: widget.value,
            onChanged: (check) => _toggle(check),
          ),
        ),
        if (widget.title != null)
          SizedBox(
            width: widget.padding ?? 8.0,
          ),
        if (widget.title != null) Text(widget.title),
      ],
    );
  }
}
