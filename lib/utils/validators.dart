class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  static emailVaildator(String email) {
    if (email.isEmpty) {
      return '\u26A0 電子郵件不可為空';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return '\u26A0 不是有效的電子郵件';
    }
    return null;
  }

  static passwordVaildator(String password) {
    if (password.isEmpty) {
      return '\u26A0 密碼不可為空';
    }
    if (password.length < 6) {
      return '\u26A0 密碼不能少於6位';
    }
    return null;
  }
}
