import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class FilledTextField extends StatelessWidget {
  final String labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final Widget? suffixIcon;
  /// 高度:字體高度 + Padding高度*2
  final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  const FilledTextField({
    super.key,
    this.labelText = 'Label',
    this.labelSize = 16.0,
    this.hintText,
    this.hintSize = 16.0,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.height = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: UiColor.text2_color),
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      textAlign: TextAlign.right,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: height),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            labelText,
            style: TextStyle(
              color: UiColor.text1_color,
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: UiColor.text2_color,
          fontSize: hintSize,
          fontWeight: FontWeight.w500,
        ),
        fillColor: UiColor.textinput_color,
        filled: true,
        border: InputBorder.none,
      ),
    );
  }
}
