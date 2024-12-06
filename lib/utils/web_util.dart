import 'package:flutter/material.dart';
import 'package:universal_html/js.dart' as js;

extension ColorString on Color {
  String toHexString() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

void setMetaThemeColor(Color color) {
  js.context.callMethod("setMetaThemeColor", [color.toHexString()]);
}