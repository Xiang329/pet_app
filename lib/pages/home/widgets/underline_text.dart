import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class UnderLineText extends StatelessWidget {
  final String text;

  /// 字體與底線間距
  final double spacing;
  final double lineWidth;

  const UnderLineText(
    this.text, {
    super.key,
    this.spacing = 2,
    this.lineWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: UiColor.text2Color,
            width: lineWidth,
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: UiColor.text2Color,
        ),
      ),
    );
  }
}
