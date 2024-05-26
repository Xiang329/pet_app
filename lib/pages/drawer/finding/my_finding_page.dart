import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/finding/found/widgets/found_list_item.dart';
import 'package:pet_app/pages/drawer/finding/missing/widgets/missing_list_item.dart';

class MyFindingPage extends StatefulWidget {
  const MyFindingPage({super.key});

  @override
  State<MyFindingPage> createState() => _MyFindingPageState();
}

class _MyFindingPageState extends State<MyFindingPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("我的遺失協尋"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: tabController,
          onTap: (value) {
            // _handleTabSelection();
          },
          indicatorColor: UiColor.text1_color,
          labelColor: UiColor.text1_color,
          unselectedLabelColor: UiColor.text2_color,
          labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '遺失'),
            Tab(text: '拾獲'),
          ],
        ),
      ),
      body: Container(
        color: UiColor.theme1_color,
        child: TabBarView(
          controller: tabController,
          children: [
            ListView.separated(
              itemCount: 2,
              itemBuilder: (context, index) {
                return const MissingListItem();
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 0),
            ),
            ListView.separated(
              itemCount: 2,
              itemBuilder: (context, index) {
                return const FoundListItem();
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
