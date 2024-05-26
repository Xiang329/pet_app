import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_page.dart';
import 'package:pet_app/pages/drawer/breeding/breeding_page.dart';
import 'package:pet_app/pages/drawer/finding/finding_page.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_page.dart';
import 'package:pet_app/pages/home/widgets/dialog/add_pet_dialog.dart';
import 'package:pet_app/pages/home/widgets/dialog/invite_code_dialog.dart';
import 'package:pet_app/pages/my/account_page.dart';
import 'package:pet_app/pages/home/home_page.dart';
import 'package:pet_app/pages/search/search_place_page.dart';
import 'package:pet_app/pages/socail/socail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/routes/app_routes.dart';

class HomeContainerPage extends StatefulWidget {
  const HomeContainerPage({super.key});

  @override
  State<HomeContainerPage> createState() => _HomeContainerPageState();
}

class _HomeContainerPageState extends State<HomeContainerPage> {
  final List<Widget> pages = [
    const HomePage(),
    const SearchPlacePage(),
    const SocialPage(),
    const AccountPage(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      body: IndexedStack(index: currentIndex, children: pages),
      // extendBody: true,
      appBar: currentIndex != 0
          ? null
          : AppBar(
              backgroundColor: UiColor.theme2_color,
              title: const Text(
                "主頁",
                style: TextStyle(
                  color: UiColor.text1_color,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: UiColor.text1_color,
                    ),
                    onPressed: () async {
                      int? result = await showDialog(
                        context: context,
                        builder: (context) {
                          return const AddPetDialog();
                        },
                      );
                      if (!context.mounted) return;

                      if (result == 1) {
                        print('選擇新增寵物');
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          useRootNavigator: true,
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
                                    builder = AppRoutes.routes["/add_pet_page"];
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
                      }
                      if (result == 2) {
                        print('選擇加入現有寵物');
                        String? result = await showDialog(
                          context: context,
                          builder: (context) {
                            return const InviteCodeDialog();
                          },
                        );
                        if (result != null) {
                          print(result);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          backgroundColor: UiColor.theme2_color,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(AssetsImages.hamsterJpg),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "名稱",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: UiColor.text1_color,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('寵物知識'),
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: UiColor.text1_color,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const PetKnowledgePage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('認領養資訊'),
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: UiColor.text1_color,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AdoptionPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('寵物配種'),
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: UiColor.text1_color,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const BreedingPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('寵物遺失'),
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: UiColor.text1_color,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const FindPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // 顏色覆蓋
          backgroundColor: UiColor.theme2_color,
          selectedItemColor: UiColor.text1_color,
          unselectedItemColor: UiColor.line_color,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.homeSvg),
              activeIcon: SvgPicture.asset(AssetsImages.homeSeletedSvg),
              label: "主頁",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.searchSvg),
              activeIcon: SvgPicture.asset(AssetsImages.searchSeletedSvg),
              label: "搜尋",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.socialSvg),
              activeIcon: SvgPicture.asset(AssetsImages.socialSeletedSvg),
              label: "社群",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.accountSvg),
              activeIcon: SvgPicture.asset(AssetsImages.accountSeletedSvg),
              label: "我的",
            ),
          ],
        ),
      ),
    );
  }
}
