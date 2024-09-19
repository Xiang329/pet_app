import 'package:intl/intl.dart';

extension DateFormatting on DateTime? {
  /// yyyy年MM月dd日
  String formatDate() {
    if (this == null) return 'Null';
    return DateFormat('yyyy年MM月dd日').format(this!);
  }

  /// yyyy/MM/dd
  String formatDateSlash() {
    if (this == null) return 'Null';
    return DateFormat('yyyy/MM/dd').format(this!);
  }

  /// yyyy-MM-dd
  String formatDateDash() {
    if (this == null) return 'Null';
    return DateFormat('yyyy-MM-dd').format(this!);
  }

  /// HH:mm
  String formatTime() {
    if (this == null) return 'Null';
    return DateFormat('HH:mm').format(this!);
  }

  /// yyyy年MM月dd日 HH:mm
  String formatDateWithTime() {
    if (this == null) return 'Null';
    return DateFormat('yyyy年MM月dd日').format(this!);
  }
}
