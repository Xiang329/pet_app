import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isHidden = true;

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthModel>(context, listen: false).login(
          emailController.text,
          passwordController.text,
        );
      } catch (e) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('登入失敗'),
              content: Text(e.toString()),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('確定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              // 自動填入
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo圖片
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset(
                        AssetsImages.logoPng,
                        height: 172,
                        width: 156,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --登入表單--
                    // 電子郵件輸入框
                    OutlinedTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.username],
                      validator: (text) => Validators.emailVaildator(text),
                      labelText: '電子郵件',
                      hintText: '電子郵件',
                    ),
                    const SizedBox(height: 30),

                    // 密碼輸入框
                    OutlinedTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.password],
                      obscureText: _isHidden,
                      validator: (text) => Validators.passwordVaildator(text),
                      labelText: '密碼',
                      hintText: '密碼',
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        icon: SvgPicture.asset(
                          _isHidden
                              ? AssetsImages.passwordHideSvg
                              : AssetsImages.passwordShowSvg,
                        ),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 忘記密碼按鈕
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/forget_password_page');
                          },
                          child: const Text(
                            '忘記密碼?',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: UiColor.text1Color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // 登入按鈕
                    SizedBox(
                      height: 42,
                      child: CustomButton(
                          asyncOnPressed: submit, buttonText: '登入'),
                    ),
                    const SizedBox(height: 24),

                    // 註冊
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '尚未建立帳號?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: UiColor.navigationBarColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register_page');
                          },
                          child: const Text(
                            '註冊',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: UiColor.text1Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
