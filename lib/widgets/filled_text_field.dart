import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class FilledTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? style;
  final String? labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final bool obscureText;
  final bool readOnly;
  final bool alignLabelWithHint;
  final int maxLines;
  final Widget? suffixIcon;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  /// FilledTextField高度:字體高度 + Padding高度*2
  // height - labelSize/2
  final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  const FilledTextField({
    super.key,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelText,
    this.labelSize = 16.0,
    this.hintText,
    this.hintSize = 16.0,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.maxLines = 1,
    this.validator,
    this.alignLabelWithHint = false,
    this.topRightRadius = 0,
    this.topLeftRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.height = 16.0,
  });

  @override
  State<FilledTextField> createState() => _FilledTextFieldState();
}

class _FilledTextFieldState extends State<FilledTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: widget.textAlign,
      style: widget.style ?? const TextStyle(color: UiColor.text1Color),
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator,
      // validator: (value) {
      //   final errorText = widget.validator?.call(value);
      //   setState(() {
      //     _errorText = errorText;
      //   });
      //   // 不使用預設的ErrorText
      //   return errorText;
      // },
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        isDense: true,
        alignLabelWithHint: widget.alignLabelWithHint,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 20.0, vertical: widget.height),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.topLeftRadius),
            topRight: Radius.circular(widget.topRightRadius),
            bottomLeft: Radius.circular(widget.bottomLeftRadius),
            bottomRight: Radius.circular(widget.bottomRightRadius),
          ),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: UiColor.text1Color,
          fontSize: widget.labelSize,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: UiColor.text1Color,
          fontSize: widget.hintSize,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: UiColor.errorColor,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        fillColor: UiColor.textinputColor,
        filled: true,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
