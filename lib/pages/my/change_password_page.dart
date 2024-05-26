import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/widgets/filled_text_field_2.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  bool _isHidden = true;
  bool _isHidden2 = true;
  bool _isHidden3 = true;

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<AuthModel>(context).loading;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        title: const Text("變更密碼"),
        backgroundColor: UiColor.theme1_color,
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
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
                    Card(
                      color: UiColor.theme1_color,
                      shadowColor: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // 目前的密碼輸入框
                          FilledTextField2(
                            controller: oldPasswordController,
                            obscureText: _isHidden,
                            labelText: '目前的密碼',
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
                          ),
                          const SizedBox(height: 10),

                          // 新密碼輸入框
                          FilledTextField2(
                            controller: newPasswordController,
                            obscureText: _isHidden2,
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
                          FilledTextField2(
                            controller: verifyPasswordController,
                            obscureText: _isHidden3,
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
                              color: UiColor.text1_color,
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
                              '完成',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () {
                        String oldPassword = oldPasswordController.text;
                        String newPassword = newPasswordController.text;
                        String verifyPassword = verifyPasswordController.text;
                        if (oldPassword == newPassword) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("錯誤"),
                                content: const Text("舊密碼與新密碼相同"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        if (newPassword != verifyPassword) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("錯誤"),
                                content: const Text("新密碼與重複密碼不一致"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        if (!isLoading) {
                          Provider.of<AuthModel>(context, listen: false)
                              .changePassword(context, oldPassword, newPassword)
                              .catchError((error) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(error.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
