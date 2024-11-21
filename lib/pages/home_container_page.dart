import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_page.dart';
import 'package:pet_app/pages/drawer/breeding/breeding_page.dart';
import 'package:pet_app/pages/drawer/finding/finding_page.dart';
import 'package:pet_app/pages/drawer/pet_knowledge/pet_knowledge_page.dart';
import 'package:pet_app/pages/home/widgets/dialog/add_pet_dialog.dart';
import 'package:pet_app/pages/home/widgets/dialog/invite_code_dialog.dart';
import 'package:pet_app/pages/my/profile_page.dart';
import 'package:pet_app/pages/home/home_page.dart';
import 'package:pet_app/pages/search/search_place_page.dart';
import 'package:pet_app/pages/socail/socail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/routes/app_routes.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:provider/provider.dart';

class HomeContainerPage extends StatefulWidget {
  const HomeContainerPage({super.key});

  @override
  State<HomeContainerPage> createState() => _HomeContainerPageState();
}

class _HomeContainerPageState extends State<HomeContainerPage> {
  final List<Widget> pages = [];
  final GlobalKey<HomePageState> homePageState = GlobalKey();
  final GlobalKey<SearchPlacePageState> searchPlacePageState = GlobalKey();
  final GlobalKey<SocialPageState> socialPageState = GlobalKey();
  final GlobalKey<ProfilePageState> profilePageState = GlobalKey();

  int currentIndex = 0;

  @override
  void initState() {
    _initializeServices();
    super.initState();
    pages.addAll([
      HomePage(key: homePageState),
      SearchPlacePage(key: searchPlacePageState),
      SocialPage(key: socialPageState),
      ProfilePage(key: profilePageState),
    ]);
  }

  Future<void> _initializeServices() async {
    try {
      Provider.of<AppProvider>(context, listen: false).initialize();
      await Future.wait([
        PetVarietiesService.getPetVarieties(),
        PetClassesService.getPetClasses(),
      ]);
    } catch (e) {
      debugPrint('初始化服務錯誤: $e');
    }
  }

  void _chagnePage(int index) {
    switch (index) {
      case 0:
        homePageState.currentState?.loadDataWithDialog();
        break;
      case 1:
        searchPlacePageState.currentState?.loadDataWithDailog();
        break;
      case 2:
        socialPageState.currentState?.loadDataWithDialog();
        break;
      case 3:
        profilePageState.currentState?.loadDataWithDailog();
        break;
    }
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final member = Provider.of<AppProvider>(context).member;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      body: IndexedStack(index: currentIndex, children: pages),
      // extendBody: true,
      appBar: currentIndex != 0
          ? null
          : AppBar(
              backgroundColor: UiColor.theme2Color,
              title: const Text("主頁"),
              leading: Builder(builder: (context) {
                return SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: IconButton(
                    icon: SvgPicture.asset(AssetsImages.menuSvg),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                );
              }),
              actions: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: UiColor.text1Color,
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
        width: MediaQuery.of(context).size.width * 0.55,
        child: Drawer(
          backgroundColor: UiColor.theme2Color,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: (member == null)
                          ? Image.asset(
                              AssetsImages.userAvatorPng,
                              width: 40 * 2,
                              height: 40 * 2,
                            )
                          : member.memberMugShot.isEmpty
                              ? Image.asset(
                                  AssetsImages.userAvatorPng,
                                  width: 40 * 2,
                                  height: 40 * 2,
                                )
                              : Image.memory(
                                  member.memberMugShot,
                                  width: 40 * 2,
                                  height: 40 * 2,
                                ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (member == null) ? '' : member.memberName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: UiColor.text1Color,
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
                  color: UiColor.text1Color,
                ),
                trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    CupertinoPageRoute<void>(
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
                  color: UiColor.text1Color,
                ),
                trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    CupertinoPageRoute<void>(
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
                  color: UiColor.text1Color,
                ),
                trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    CupertinoPageRoute<void>(
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
                  color: UiColor.text1Color,
                ),
                trailing: SvgPicture.asset(AssetsImages.arrowEnterSvg),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push<void>(
                    context,
                    CupertinoPageRoute<void>(
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
          onTap: _chagnePage,
          type: BottomNavigationBarType.fixed, // 顏色覆蓋
          backgroundColor: UiColor.theme2Color,
          selectedItemColor: UiColor.text1Color,
          unselectedItemColor: UiColor.lineColor,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.homeSvg),
              activeIcon: SvgPicture.asset(AssetsImages.homeSeletedSvg),
              label: "主頁",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsImages.findPlaceSvg),
              activeIcon: SvgPicture.asset(AssetsImages.findPlaceSeletedSvg),
              label: "找店家",
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
