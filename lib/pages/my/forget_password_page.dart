import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context, listen: false).user;
    final userEmail = user?.email;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        title: const Text("忘記密碼"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "我們將傳送修改密碼連結給你",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text1_color,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "我們將連結傳送到$userEmail。",
                      style: const TextStyle(
                        fontSize: 16,
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
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 32.5,
                          backgroundImage: AssetImage(AssetsImages.dogJpg),
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Angelina",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1_color,
                          ),
                        )
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                // 繼續按鈕
                SizedBox(
                  height: 42,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: UiColor.theme2_color),
                    child: const Text(
                      '繼續',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (user != null) {
                        Provider.of<AuthModel>(context, listen: false)
                            .resetPassword(userEmail!);
                      }
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text('忘記密碼'),
                            content: const Text('已發送電子郵件。'),
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
