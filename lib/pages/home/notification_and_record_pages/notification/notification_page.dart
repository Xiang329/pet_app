import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/notification/add_notification_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/notification/edit_notification_page.dart';
import 'package:pet_app/providers/item_provider.dart';
import 'package:pet_app/widgets/slidable_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("通知"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SlidableAutoCloseBehavior(
              // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
              // 否則出錯A dismissed Slidable widget is still part of the tree.
              child: Consumer<ItemProvider>(builder: (context, provider, _) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.notifyItem.length,
                  itemBuilder: (context, index) {
                    return SlidableItem(
                      itemList: provider.notifyItem,
                      item: provider.notifyItem[index],
                      onTap: () {
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
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
                                return CupertinoPageRoute(
                                    builder: (context) =>
                                        const EditNotificationPage(),
                                    settings: settings);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 0),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UiColor.theme2_color,
        shape: const CircleBorder(),
        onPressed: () {
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
                      builder: (context) => const AddNotificationPage(),
                      settings: settings);
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
