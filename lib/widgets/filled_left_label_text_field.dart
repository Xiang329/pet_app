import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';

class FilledLeftLabelTextField extends StatelessWidget {
  final String labelText;
  final double labelSize;
  final String? hintText;
  final double hintSize;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final Widget? suffixIcon;

  /// FilledLeftLabelTextField高度:字體高度 + Padding高度*2
  final double height;
  final Function()? onTap;
  final FormFieldValidator? validator;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  const FilledLeftLabelTextField({
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
    this.topRightRadius = 0,
    this.topLeftRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: UiColor.text2Color),
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
              color: UiColor.text1Color,
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: UiColor.text2Color,
          fontSize: hintSize,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: UiColor.errorColor,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        fillColor: UiColor.textinputColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            topRight: Radius.circular(topRightRadius),
            bottomLeft: Radius.circular(bottomLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius),
          ),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
