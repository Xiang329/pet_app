import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/notify_list_page.dart';
import 'package:pet_app/pages/home/pet_list_page.dart';
import 'package:pet_app/pages/home/widgets/comming_soon_notify_list_item.dart';
import 'package:pet_app/providers/common_soon_notify_provider.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:pet_app/pages/home/widgets/pet_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic memberProvider;

  @override
  void initState() {
    super.initState();
    memberProvider =
        Provider.of<MemberProvider>(context, listen: false).updateMember();
  }

  @override
  Widget build(BuildContext context) {
    final notifys =
        Provider.of<CommonSoonNotifyProvider>(context, listen: false).notifys;
    final pets = Provider.of<MemberProvider>(context).pets!;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "我的寵物",
                  style: TextStyle(
                      color: UiColor.text1_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Visibility(
                  visible: pets.length > 3 ? true : false,
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: UiColor.text1_color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PetListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: memberProvider,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return SlidableAutoCloseBehavior(
                    // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
                    // 否則出錯A dismissed Slidable widget is still part of the tree.
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pets.length <= 3 ? pets.length : 3,
                      itemBuilder: (context, index) {
                        return PetItem(
                          pet: pets[index],
                          petIndex: index,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 0),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "即將到來",
                  style: TextStyle(
                      color: UiColor.text1_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Visibility(
                  visible: notifys.length > 3 ? true : false,
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: UiColor.text1_color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifyListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SlidableAutoCloseBehavior(
              // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
              // 否則出錯A dismissed Slidable widget is still part of the tree.
              child: Consumer<CommonSoonNotifyProvider>(
                builder: (context, provider, _) {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.notifys.length <= 3
                        ? provider.notifys.length
                        : 3,
                    itemBuilder: (context, index) {
                      return CommingSoonNotifyItem(
                        notify: provider.notifys[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
