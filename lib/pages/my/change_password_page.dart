import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  bool _isHidden = true;
  bool _isHidden2 = true;
  bool _isHidden3 = true;

  Future submit() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String verifyPassword = verifyPasswordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        if (oldPassword == newPassword) {
          throw '舊密碼與新密碼相同';
        }
        if (newPassword != verifyPassword) {
          throw '新密碼和確認的密碼不相同';
        }
        await Provider.of<AuthModel>(context, listen: false)
            .changePassword(context, oldPassword, newPassword)
            .then((_) {
          if (!mounted) return;
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('通知'),
                content: const Text('變更密碼成功。'),
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
        });
        if (!mounted) return;
        Navigator.of(context).pop();
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
        title: const Text("變更密碼"),
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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            padding:
                const EdgeInsets.only(top: 50, left: 28, right: 28, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // 目前的密碼輸入框
                          FilledTextField(
                            controller: oldPasswordController,
                            obscureText: _isHidden,
                            labelText: '目前的密碼',
                            validator: (value) =>
                                Validators.passwordVaildator(value),
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              icon: SvgPicture.asset(_isHidden
                                  ? AssetsImages.passwordHideSvg
                                  : AssetsImages.passwordShowSvg),
                              onPressed: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                            ),
                            topLeftRadius: 8,
                            topRightRadius: 8,
                          ),
                          const SizedBox(height: 10),

                          // 新密碼輸入框
                          FilledTextField(
                            controller: newPasswordController,
                            obscureText: _isHidden2,
                            validator: (value) =>
                                Validators.passwordVaildator(value),
                            labelText: '新密碼',
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              icon: SvgPicture.asset(_isHidden2
                                  ? AssetsImages.passwordHideSvg
                                  : AssetsImages.passwordShowSvg),
                              onPressed: () {
                                setState(() {
                                  _isHidden2 = !_isHidden2;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 再次輸入新密碼輸入框
                          FilledTextField(
                            controller: verifyPasswordController,
                            obscureText: _isHidden3,
                            validator: (value) =>
                                Validators.passwordVaildator(value),
                            labelText: '再次輸入新密碼',
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              icon: SvgPicture.asset(_isHidden3
                                  ? AssetsImages.passwordHideSvg
                                  : AssetsImages.passwordShowSvg),
                              onPressed: () {
                                setState(() {
                                  _isHidden3 = !_isHidden3;
                                });
                              },
                            ),
                            bottomLeftRadius: 8,
                            bottomRightRadius: 8,
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
                          child: const Text(
                            "忘記密碼?",
                            style: TextStyle(
                              color: UiColor.text1Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/forget_password_page2");
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // 修改密碼按鈕
                SizedBox(
                  height: 42,
                  child: CustomButton(asyncOnPressed: submit, buttonText: '保存'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
