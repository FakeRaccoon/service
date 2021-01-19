import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final icon;
  final keyboardType;
  final readOnly;
  final onTap;
  final controller;
  final enable;
  final onChange;
  final prefix;
  final inputFormat;
  final validator;

  const CustomTextField(
      {Key key,
      this.icon,
      this.keyboardType,
      this.readOnly,
      this.onTap,
      this.controller,
      this.enable, this.onChange, this.prefix, this.inputFormat, this.validator})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      inputFormatters: widget.inputFormat,
      onChanged: widget.onChange,
      enabled: widget.enable,
      controller: widget.controller,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefix: widget.prefix,
        suffixIcon: widget.icon,
      ),
    );
  }
}
