import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/home/widgets/comming_soon_notify_list_item.dart';
import 'package:pet_app/providers/common_soon_notify_provider.dart';
import 'package:provider/provider.dart';

class NotifyListPage extends StatefulWidget {
  const NotifyListPage({super.key});

  @override
  State<NotifyListPage> createState() => _NotifyListPageState();
}

class _NotifyListPageState extends State<NotifyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text('即將到來'),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "今天",
              style: TextStyle(
                  color: UiColor.text1_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
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
            const SizedBox(height: 20),
            const Text(
              "七天內通知",
              style: TextStyle(
                  color: UiColor.text1_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
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
