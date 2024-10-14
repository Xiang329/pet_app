import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class DelAccountPage extends StatefulWidget {
  const DelAccountPage({super.key});

  @override
  State<DelAccountPage> createState() => _DelAccountPageState();
}

class _DelAccountPageState extends State<DelAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;

  Future submit() async {
    Member? member = Provider.of<AppProvider>(context, listen: false).member;
    if (_formKey.currentState!.validate()) {
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
                    color: UiColor.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await Provider.of<AuthModel>(context, listen: false)
                        .deleteUserAccount(
                            member!.memberId, passwordController.text)
                        .then((_) {
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                    });
                  } catch (e) {
                    if (!context.mounted) return;
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
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        title: const Text("刪除帳號"),
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "刪除您的帳號?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: UiColor.text1Color,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "如果您選擇刪除， \n我們將在伺服器上刪除您的帳戶及相關資料。",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: UiColor.text2Color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "請重新輸入密碼來完成操作。",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: UiColor.text2Color,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 密碼輸入框
                      FilledTextField(
                        controller: passwordController,
                        obscureText: _isHidden,
                        validator: (value) =>
                            Validators.passwordVaildator(value),
                        labelText: '密碼',
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
                        topLeftRadius: 8,
                        topRightRadius: 8,
                        bottomLeftRadius: 8,
                        bottomRightRadius: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                // 確認刪除按鈕
                SizedBox(
                  height: 42,
                  child: CustomButton(
                    asyncOnPressed: submit,
                    buttonText: '確認刪除',
                    errorStyle: true,
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
