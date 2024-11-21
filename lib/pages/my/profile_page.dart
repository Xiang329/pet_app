import 'package:flutter_svg/svg.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Future<void> loadDataWithDailog() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await CommonDialog.showRefreshDialog(
      context: context,
      futureFunction: appProvider.updateMember,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final member = appProvider.member;

    return Scaffold(
      backgroundColor: UiColor.theme2Color,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 156),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight - 156),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: UiColor.theme1Color,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      member == null
                          ? const CircularProgressIndicator()
                          : Text(
                              member.memberName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      const SizedBox(height: 50),
                      ListTile(
                        leading:
                            SvgPicture.asset(AssetsImages.profileButtonSvg),
                        title: const Text('個人檔案',
                            style: TextStyle(color: UiColor.text1Color)),
                        trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
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
                                      builder =
                                          AppRoutes.routes["/profile_page"];
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
                          style: TextStyle(color: UiColor.text1Color),
                        ),
                        trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
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
                                          color: UiColor.errorColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Provider.of<AppProvider>(context,
                                              listen: false)
                                          .initialize();
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
              Positioned(
                left: 0,
                right: 0,
                top: -56,
                child: CircleAvatar(
                  // 外環效果
                  radius: 56,
                  backgroundColor: UiColor.theme2Color,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: UiColor.theme1Color,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: (member == null)
                          ? const AssetImage(AssetsImages.userAvatorPng)
                          : member.memberMugShot.isEmpty
                              ? const AssetImage(AssetsImages.userAvatorPng)
                              : MemoryImage(member.memberMugShot),
                    ),
                  ),
                ),
              ),

              // 背景裝飾
              Positioned(
                left: 0,
                right: 0,
                top: -156,
                child: SvgPicture.asset(
                  AssetsImages.backgroundEffectSvg,
                  width: 375,
                  // fit: BoxFit.fill,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
