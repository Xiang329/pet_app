import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class FilledTextField2 extends StatelessWidget {
  final String labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;

  /// 高度:字體高度*2 + Padding高度*2
  // height - labelSize/2
  // final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  const FilledTextField2({
    super.key,
    this.labelText = 'Label',
    this.labelSize = 16.0,
    this.hintText,
    this.hintSize = 16.0,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.validator,
    // this.height = 15.0,
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        labelText: labelText,
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
        fillColor: UiColor.textinput_color,
        filled: true,
        suffixIcon: suffixIcon,
        border: InputBorder.none,
      ),
    );
  }
}
