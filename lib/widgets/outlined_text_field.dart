import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  final String? labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool readOnly;
  final bool alignLabelWithHint;
  final int? maxLines;
  final Widget? suffixIcon;

  /// OutlinedTextField高度:字體高度 + Padding高度*2
  final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  const OutlinedTextField({
    super.key,
    this.labelText,
    this.labelSize = 16.0,
    this.hintText,
    this.hintSize = 16.0,
    required this.controller,
    this.keyboardType,
    this.autofillHints,
    this.obscureText = false,
    this.readOnly = false,
    this.alignLabelWithHint = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.height = 15.0,
  });

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  bool _hasError = false;
  bool _hasValue = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: UiColor.text1Color),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      // validator: widget.validator,
      validator: (value) {
        final errorText = widget.validator?.call(value);
        setState(() {
          _hasError = errorText != null;
        });
        // 不使用預設的ErrorText
        return errorText;
      },
      maxLines: widget.maxLines,
      onChanged: (value) {
        setState(() {
          _hasValue = value.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        alignLabelWithHint: widget.alignLabelWithHint,
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 20.0, vertical: widget.height),
        labelText: widget.labelText,
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: _hasError ? UiColor.errorColor : UiColor.text2Color,
          fontSize: widget.labelSize,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: UiColor.text2Color,
          fontSize: widget.hintSize,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: UiColor.errorColor,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            width: (widget.controller.text.isNotEmpty || _hasValue) ? 2 : 1,
            color: UiColor.navigationBarColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: UiColor.text1Color),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.errorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.errorColor)),
      ),
    );
  }
}
