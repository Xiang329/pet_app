import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        title: const Text('忘記密碼'),
        backgroundColor: UiColor.theme1_color,
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
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

                  // --忘記密碼表單--
                  // 電子郵件輸入框
                  OutlinedTextField(
                    controller: emailController,
                    validator: (text) {
                      return Validators.emailVaildator(text);
                    },
                    labelText: '電子郵件',
                    hintText: '電子郵件',
                  ),
                  const SizedBox(height: 48),

                  // 修改密碼按鈕
                  SizedBox(
                    height: 42,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: UiColor.theme2_color),
                        child: const Text(
                          '修改密碼',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<AuthModel>(context, listen: false)
                              .resetPassword(
                            emailController.text,
                          );
                        }),
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
