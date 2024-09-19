import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/notification.dart';
import 'package:pet_app/pages/home/widgets/upcoming_notification_list_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:provider/provider.dart';

class NotifyListPage extends StatefulWidget {
  const NotifyListPage({super.key});

  @override
  State<NotifyListPage> createState() => _NotifyListPageState();
}

class _NotifyListPageState extends State<NotifyListPage> {
  DateTime now = DateTime.now();
  late DateTime todayStart;
  late DateTime todayEnd;
  late DateTime sevenDaysLater;
  final List<CommingSoonNotification> today = [];
  final List<CommingSoonNotification> withinSevenDays = [];

  @override
  void initState() {
    super.initState();
    todayStart = DateTime(now.year, now.month, now.day);
    todayEnd = todayStart.add(const Duration(days: 1));
    sevenDaysLater = todayStart.add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    today.clear();
    withinSevenDays.clear();
    final allNotifications =
        Provider.of<AppProvider>(context).allNotifications;

    // 日期分類
    for (var notification in allNotifications) {
      if (notification.dateTime != null) {
        DateTime notificationDate = notification.dateTime!;

        if (notificationDate.isAfter(todayStart) &&
            notificationDate.isBefore(todayEnd)) {
          today.add(notification);
        } else if (notificationDate.isAfter(todayEnd) &&
            notificationDate.isBefore(sevenDaysLater)) {
          withinSevenDays.add(notification);
        }
      }
    }
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text('即將到來'),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                  color: UiColor.text1Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SlidableAutoCloseBehavior(
              // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
              // 否則出錯A dismissed Slidable widget is still part of the tree.
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: today.length,
                itemBuilder: (context, index) {
                  return UpcomingNotificationListItem(
                    notification: today[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "七天內通知",
              style: TextStyle(
                  color: UiColor.text1Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SlidableAutoCloseBehavior(
              // 使用 Slidable 時，如果使用 ListView.builder，則不可以設定itemExtent調整子元件高度，
              // 否則出錯A dismissed Slidable widget is still part of the tree.
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: withinSevenDays.length,
                itemBuilder: (context, index) {
                  return UpcomingNotificationListItem(
                    notification: withinSevenDays[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
