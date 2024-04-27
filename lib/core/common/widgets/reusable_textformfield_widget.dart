import 'package:flutter/material.dart';

class ReusableTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;

  const ReusableTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.borderRadius = 8.0,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  });

  @override
  State<ReusableTextFormField> createState() => _ReusableTextFormFieldState();
}

class _ReusableTextFormFieldState extends State<ReusableTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        contentPadding: widget.contentPadding,
        suffixIcon: widget.obscureText
            ? _obscureText
                ? IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = false;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = true;
                      });
                    },
                  )
            : null,
      ),
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
