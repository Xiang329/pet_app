import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart';

extension ColorString on Color {
  String toHexString() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

void setMetaThemeColor(Color color) {
  js.context.callMethod("setMetaThemeColor", [color.toHexString()]);
}

bool isSafariPwa() {
  const List<String> displayModes = [
    'fullscreen',
    'standalone',
    'minimal-ui',
  ];
  // 檢查是否是iOS的Web
  final isWebiOS = kIsWeb && Platform.isIOS;

  // 檢查是否安裝為PWA
  bool isPwaDisplayMode = displayModes.any((displayMode) {
    return html.window.matchMedia('(display-mode: $displayMode)').matches;
  });
  
  return isWebiOS && isPwaDisplayMode;
}