import 'package:flutter/material.dart';

class ReusableDropdown<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final Widget Function(T?)? itemBuilder;

  const ReusableDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.itemBuilder,
  }) : super(key: key);

  @override
  ReusableDropdownState<T> createState() => ReusableDropdownState<T>();
}

class ReusableDropdownState<T> extends State<ReusableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: widget.value,
      items: widget.items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: widget.itemBuilder != null
              ? widget.itemBuilder!(value)
              : Text(value.toString()),
        );
      }).toList(),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
