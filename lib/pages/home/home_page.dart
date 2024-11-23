import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/notify_list_page.dart';
import 'package:pet_app/pages/home/pet_list_page.dart';
import 'package:pet_app/pages/home/widgets/upcoming_notification_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/pages/home/widgets/pet_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future? loadData;
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData = _loadPetData();
  }

  Future<void> _loadPetData() async {
    await Provider.of<AppProvider>(context, listen: false)
        .updateMember()
        .catchError(
      (e) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          barrierDismissible: true,
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
      },
    );
  }

  Future<void> loadDataWithDialog() async {
    if (!hasLoaded) return;
    await CommonDialog.showRefreshDialog(
      context: context,
      futureFunction: _loadPetData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final petManagement = Provider.of<AppProvider>(context).petManagement;
    final allNotifications = Provider.of<AppProvider>(context).allNotifications;
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "我的寵物",
                  style: TextStyle(
                      color: UiColor.text1Color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Visibility(
                  visible: petManagement.length > 3 ? true : false,
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: UiColor.text1Color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const PetListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              hasLoaded = true;
              if (petManagement.isEmpty) {
                return const Center(child: EmptyData(text: '快來建立第一隻寵物吧'));
              }
              return SlidableAutoCloseBehavior(
                // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
                // 否則出錯A dismissed Slidable widget is still part of the tree.
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      petManagement.length <= 3 ? petManagement.length : 3,
                  itemBuilder: (context, index) {
                    return PetItem(
                      petManagement: petManagement[index],
                      petIndex: index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "即將到來",
                  style: TextStyle(
                      color: UiColor.text1Color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Visibility(
                  visible: allNotifications.length > 3 ? true : false,
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: UiColor.text1Color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const NotifyListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (allNotifications.isEmpty) {
                  return const Center(child: EmptyData(text: '尚無通知'));
                }
                return SlidableAutoCloseBehavior(
                  // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
                  // 否則出錯A dismissed Slidable widget is still part of the tree.
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allNotifications.length <= 3
                        ? allNotifications.length
                        : 3,
                    itemBuilder: (context, index) {
                      return UpcomingNotificationListItem(
                        notification: allNotifications[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
