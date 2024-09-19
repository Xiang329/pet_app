import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/finding/found/my_found_list_page.dart';
import 'package:pet_app/pages/drawer/finding/missing/my_missing_list_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:provider/provider.dart';

class MyFindingPage extends StatefulWidget {
  const MyFindingPage({super.key});

  @override
  State<MyFindingPage> createState() => _MyFindingPageState();
}

class _MyFindingPageState extends State<MyFindingPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Future loadData;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loadData = Provider.of<AppProvider>(context, listen: false)
        .fetchMyPetFindings()
        .catchError((e) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("我的遺失協尋"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: UiColor.text1Color,
          labelColor: UiColor.text1Color,
          unselectedLabelColor: UiColor.text2Color,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '遺失'),
            Tab(text: '拾獲'),
          ],
        ),
      ),
      body: Container(
        color: UiColor.theme1Color,
        child: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return TabBarView(
                controller: tabController,
                children: const [
                  MyMissingListPage(),
                  MyFoundListPage(),
                ],
              );
            }),
      ),
    );
  }
}
