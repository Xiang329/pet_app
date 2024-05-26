import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/comming_soon_notfy.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/notification/edit_notification_page.dart';
// import 'package:pet_app/pages/home/notify_list_page.dart';
import 'package:pet_app/providers/common_soon_notify_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CommingSoonNotifyItem extends StatefulWidget {
  final CommingSoonNotify notify;
  // final VoidCallback onDismissed; // 添加回調函數
  // const CommingSoonNotifyItem({super.key, required this.pet, required this.onDismissed});
  const CommingSoonNotifyItem({super.key, required this.notify});

  @override
  State<CommingSoonNotifyItem> createState() => _CommingSoonNotifyItemState();
}

class _CommingSoonNotifyItemState extends State<CommingSoonNotifyItem> {
  // 必須確保更新狀態，否則出錯 A dismissed Slidable widget is still part of the tree.
  // 只需在回調中移除相應的 Pet 對象
  void removeData() {
    // widget.onDismissed();
    Provider.of<CommonSoonNotifyProvider>(context, listen: false)
        .removePet(widget.notify);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Center(child: Text('通知 ${widget.notify.title} 刪除成功')),
      duration: const Duration(seconds: 1),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 120,
        child: Card(
          color: UiColor.textinput_color,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                clipBehavior: Clip.antiAlias,
                useRootNavigator: true,
                isScrollControlled: true,
                context: context,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.90,
                ),
                builder: (BuildContext context) {
                  return Navigator(
                    onGenerateRoute: (settings) {
                      return CupertinoPageRoute(
                          builder: (context) => const EditNotificationPage());
                    },
                  );
                },
              );
            },
            child: Slidable(
              // 如果 Slidable 可以關閉，需指定一個不重複的 Key
              key: UniqueKey(),

              // 右測滑塊設置
              endActionPane: ActionPane(
                // 寬度比例
                extentRatio: 0.25,
                dismissible: DismissiblePane(onDismissed: () {
                  removeData();
                }),
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => removeData(),
                    backgroundColor: const Color(0xffe35050),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: commingSoonNotifyListItem(widget.notify),
            ),
          ),
        ),
      ),
    );
  }

  Widget commingSoonNotifyListItem(CommingSoonNotify notify) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(AssetsImages.dogJpg),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.notifications_active,
                        size: 16, color: UiColor.theme2_color)),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              notify.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: UiColor.text1_color,
              ),
            ),
            const SizedBox(height: 5),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    notify.time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: UiColor.text2_color,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 26,
                    color: UiColor.text2_color,
                  ),
                  Text(
                    notify.petName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: UiColor.text2_color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
