import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/widgets/filled_text_field_2.dart';
import 'package:provider/provider.dart';

class DelAccountPage extends StatefulWidget {
  const DelAccountPage({super.key});

  @override
  State<DelAccountPage> createState() => _DelAccountPageState();
}

class _DelAccountPageState extends State<DelAccountPage> {
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context, listen: false).user;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        title: const Text("刪除帳號"),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "刪除您的帳號?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text1_color,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "如果您選擇刪除， \n我們將在伺服器上刪除您的帳戶及相關資料。",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: UiColor.text2_color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "請重新輸入密碼來完成操作。",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: UiColor.text2_color,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 密碼輸入框
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: FilledTextField2(
                        controller: passwordController,
                        obscureText: _isHidden,
                        labelText: '再次輸入新密碼',
                        suffixIcon: IconButton(
                          alignment: Alignment.center,
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                // 確認刪除按鈕
                SizedBox(
                  height: 42,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: const Color(0xffe35050)),
                    child: const Text(
                      '確認刪除',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text('刪除帳號'),
                            content: const Text('刪除帳號後，您將無法在使用該帳號登入。確定要繼續嗎？'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text(
                                  '刪除',
                                  style: TextStyle(
                                      color: Color(0xffe35050),
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  if (user != null) {
                                    Provider.of<AuthModel>(context,
                                            listen: false)
                                        .deleteUserAccount(
                                            passwordController.text);
                                  }
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
