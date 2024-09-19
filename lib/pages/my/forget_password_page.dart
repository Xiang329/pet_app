import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  Future submit() async {
    try {
      await Provider.of<AuthModel>(context, listen: false)
          .resetPassword()
          .then((_) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('通知'),
              content: const Text('已發送密碼重設鏈接的電子郵件。'),
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
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('發送失敗'),
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

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final member = appProvider.member;
    final memberEmail = appProvider.memberEmail;

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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
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
                        color: UiColor.text1Color,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "我們將連結傳送到$memberEmail",
                      style: const TextStyle(
                        fontSize: 16,
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32.5,
                          backgroundImage: member == null
                              ? null
                              : member.memberMugShot.isEmpty
                                  ? null
                                  : MemoryImage(member.memberMugShot),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            '${member?.memberName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: UiColor.text1Color,
                            ),
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
                  child: CustomButton(asyncOnPressed: submit, buttonText: '繼續'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
