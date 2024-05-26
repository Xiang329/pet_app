import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class DividerRow extends StatelessWidget {
  final List<Widget> children;

  /// 元件之間間距
  final double? spacing;

  /// 分隔線的粗細
  final double? lineWidth;

  const DividerRow({
    super.key,
    required this.children,
    this.spacing = 26.0,
    this.lineWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < children.length; i++) {
      Widget child = children[i];

      // 如果是Text組件，用Flexible包裹
      if (child is Text) {
        child = Flexible(child: child);
      }

      rowChildren.add(child);

      if (i != children.length - 1) {
        rowChildren.add(
          VerticalDivider(
            thickness: lineWidth,
            width: spacing,
            color: UiColor.text2_color,
          ),
        );
      }
    }

    return IntrinsicHeight(
      child: Row(
        children: rowChildren,
      ),
    );
  }
}
