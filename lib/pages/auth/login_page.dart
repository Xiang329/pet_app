import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/utils/validators.dart';
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
  late final bool isError;

  @override
  void initState() {
    emailController.text = 'test@email.com';
    passwordController.text = '123456';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<AuthModel>(context).loading;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo圖片
                  SvgPicture.asset(
                    AssetsImages.loginLogoSvg,
                  ),

                  const SizedBox(height: 52),

                  // --登入表單--
                  // 電子郵件輸入框
                  OutlinedTextField(
                    controller: emailController,
                    validator: (text) {
                      return Validators.emailVaildator(text);
                    },
                    labelText: '電子郵件',
                    hintText: '電子郵件',
                  ),
                  const SizedBox(height: 30),

                  // 密碼輸入框
                  OutlinedTextField(
                    controller: passwordController,
                    obscureText: _isHidden,
                    validator: (text) {
                      return Validators.passwordVaildator(text);
                    },
                    labelText: '密碼',
                    hintText: '密碼',
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          icon: SvgPicture.asset(_isHidden
                              ? AssetsImages.passwordHideSvg
                              : AssetsImages.passwordShowSvg),
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                        ),
                      ],
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
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF593922)),
                          )),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 登入按鈕
                  SizedBox(
                    height: 42,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: UiColor.theme2_color),
                      child: isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '登入',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     margin: EdgeInsets.only(
                        //       left: MediaQuery.of(context).size.width * 0.2,
                        //       right: MediaQuery.of(context).size.width * 0.2,
                        //       bottom: MediaQuery.of(context).size.height * 0.5,
                        //     ),
                        //     elevation: 0,
                        //     duration: const Duration(seconds: 2),
                        //     behavior: SnackBarBehavior.floating,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     backgroundColor: Colors.black.withOpacity(0.5),
                        //     content: const Center(
                        //       child: Text(
                        //         'Please enter valid email',
                        //       ),
                        //     ),
                        //   ),
                        // );
                        if (_formKey.currentState!.validate()) {
                          if (!isLoading) {
                            Provider.of<AuthModel>(context, listen: false)
                                .login(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 註冊
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 文字
                      const Text(
                        '尚未建立帳號?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFB2A990),
                        ),
                      ),
                      // 文字按鈕
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register_page');
                        },
                        child: const Text(
                          '註冊',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF593922),
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
    );
  }
}
