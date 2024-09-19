import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class RichTextDivider extends StatelessWidget {
  final List<InlineSpan> children;
  final TextOverflow overflow;

  /// 組件佔用寬用
  final double? width;

  /// 線條粗細
  final double? thickness;

  const RichTextDivider({
    super.key,
    required this.children,
    this.width = 26.0,
    this.thickness = 1.5,
    this.overflow = TextOverflow.ellipsis,
  });

  // 取得Text組件的大小
  Size getTextSize(InlineSpan text) {
    return (TextPainter(
            text: text, maxLines: 1, textDirection: TextDirection.ltr)
          ..layout())
        .size;
  }

  @override
  Widget build(BuildContext context) {
    double textHeight = 0;
    List<InlineSpan> rowChildren = [];

    // 先確保Children中有TextSpan，再取得高度
    for (var child in children) {
      if (child is TextSpan && textHeight == 0) {
        textHeight = getTextSize(child).height;
        break;
      }
    }

    // 在Children之間插入
    for (int i = 0; i < children.length; i++) {
      rowChildren.add(children[i]);
      if (i != children.length - 1) {
        rowChildren.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              height: textHeight,
              child: IntrinsicHeight(
                child: VerticalDivider(
                  thickness: thickness,
                  width: width,
                  color: UiColor.text2Color,
                ),
              ),
            ),
          ),
        );
      }
    }

    return RichText(
      overflow: overflow,
      text: TextSpan(children: rowChildren),
    );
  }
}
