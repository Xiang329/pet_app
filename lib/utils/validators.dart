import 'package:intl/intl.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  static String? emailVaildator(String email) {
    if (email.isEmpty) {
      return '\u26A0 電子郵件不可為空';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return '\u26A0 不是有效的電子郵件';
    }
    return null;
  }

  static String? passwordVaildator(String password) {
    if (password.isEmpty) {
      return '\u26A0 密碼不可為空';
    }
    if (password.contains(' ')) {
      return '\u26A0 密碼不可以包含空格';
    }
    if (password.length < 6) {
      return '\u26A0 密碼不能少於 6 位';
    }
    return null;
  }

  static String? stringValidator(
    String value, {
    int minLength = 1,
    int maxLength = 255,
    int? fixedLength,
    String errorMessage = '',
    bool onlyInt = false,
  }) {
    if (value.trim().isEmpty) {
      return '\u26A0 $errorMessage不可為空';
    }
    if (onlyInt == true) {
      try {
        int.parse(value);
        return null;
      } catch (e) {
        return '\u26A0 請輸入有效的數字';
      }
    }
    if (fixedLength != null) {
      if (value.length != fixedLength) {
        return '\u26A0 $errorMessage長度必須為 $fixedLength 位';
      }
    } else {
      if (value.length < minLength) {
        return '\u26A0 $errorMessage長度至少為 $minLength 位';
      }
      if (value.length > maxLength) {
        return '\u26A0 $errorMessage長度不能超過 $maxLength 位';
      }
    }
    return null;
  }

  static String? phoneValidator(String value) {
    if (value.trim().isEmpty) {
      return '\u26A0 行動電話不可為空';
    }
    if (!value.trim().startsWith('09')) {
      return '\u26A0 行動電話為 09 開頭';
    }
    if (value.length != 10) {
      return '\u26A0 行動電話長度必須為 10 位';
    }
    return null;
  }

  static String? dateTimeValidator(String value) {
    if (value.isEmpty) {
      return '\u26A0 日期不可為空';
    }
    try {
      final DateFormat dateFormat = DateFormat('yyyy年MM月dd日');
      dateFormat.parseStrict(value);
    } catch (e) {
      try {
        final DateFormat timeFormat = DateFormat('HH:mm');
        timeFormat.parseStrict(value);
      } catch (e) {
        return '\u26A0 不是有效的日期時間格式';
      }
    }
    return null;
  }

  static String? dropDownListValidator(
    String? value, {
    String? errorMessage,
  }) {
    if (value == null) {
      return '\u26A0 請選擇$errorMessage';
    }
    return null;
  }
}
