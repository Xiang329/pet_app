import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context, listen: false).user;

    return Scaffold(
      backgroundColor: UiColor.theme2_color,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: UiColor.theme1_color,
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "${user?.email}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 57),
                    ListTile(
                      leading: SvgPicture.asset(AssetsImages.profileButtonSvg),
                      title: const Text('個人檔案',
                          style: TextStyle(color: UiColor.text1_color)),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
                          isScrollControlled: true,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.90,
                          ),
                          builder: (BuildContext context) {
                            return Navigator(
                              onGenerateRoute: (settings) {
                                final WidgetBuilder? builder;
                                switch (settings.name) {
                                  case '/':
                                    builder = AppRoutes.routes["/profile_page"];
                                    break;
                                  default:
                                    builder = AppRoutes.routes[settings.name];
                                }
                                if (builder != null) {
                                  return CupertinoPageRoute(
                                      builder: builder, settings: settings);
                                } else {
                                  throw Exception('路由名稱有誤: ${settings.name}');
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: SvgPicture.asset(AssetsImages.logoutButtonSvg),
                      title: const Text(
                        '登出',
                        style: TextStyle(color: UiColor.text1_color),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('登出您的帳號?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                    child: const Text('取消'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                CupertinoDialogAction(
                                  child: const Text(
                                    '登出',
                                    style: TextStyle(
                                        color: Color(0xffe35050),
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Provider.of<AuthModel>(context,
                                            listen: false)
                                        .logout();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            //圓形頭像
            const Positioned(
              top: -56,
              child: CircleAvatar(
                // 外環效果
                radius: 56,
                backgroundColor: UiColor.theme2_color,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(AssetsImages.catJpg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
