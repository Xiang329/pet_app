import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  final String labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool alignLabelWithHint;
  final int? maxLines;
  final Widget? suffixIcon;

  /// 高度:字體高度 + Padding高度*2
  final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  const OutlinedTextField({
    super.key,
    this.labelText = 'Label',
    this.labelSize = 16.0,
    this.hintText,
    this.hintSize = 16.0,
    this.controller,
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
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: UiColor.text1_color),
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        alignLabelWithHint: alignLabelWithHint,
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 20.0, vertical: height),
        labelText: labelText,
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: UiColor.text1_color,
          fontSize: labelSize,
          fontWeight: FontWeight.w600,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: UiColor.text1_color,
          fontSize: hintSize,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFDA1414),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: UiColor.navigationBar_color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: UiColor.text1_color),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xB3DA1414))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xB3DA1414))),
      ),
    );
  }
}
