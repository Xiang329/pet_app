import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
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

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthModel>(context, listen: false)
            .resetPassword(
          email: emailController.text,
        )
            .then(
          (_) {
            if (!mounted) return;
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('通知'),
                  content: const Text('如果該電子郵件地址已經註冊，您將收到一封密碼重設鏈接的電子郵件。'),
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
          },
        );
      } catch (e) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('錯誤'),
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
      appBar: AppBar(
        title: const Text('忘記密碼'),
        backgroundColor: UiColor.theme1Color,
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                    child: CustomButton(
                        asyncOnPressed: submit, buttonText: '發送電子郵件通知'),
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
