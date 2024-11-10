import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/advice.dart';
import 'package:pet_app/model/drug.dart';
import 'package:pet_app/model/notification.dart';
import 'package:pet_app/model/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/advices_serivce.dart';
import 'package:pet_app/services/durgs_serivce.dart';
import 'package:pet_app/services/vaccines_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';
import 'package:provider/provider.dart';

class UpcomingNotificationListItem extends StatefulWidget {
  final CommingSoonNotification notification;
  const UpcomingNotificationListItem({
    super.key,
    required this.notification,
  });

  @override
  State<UpcomingNotificationListItem> createState() =>
      _UpcomingNotificationListItemState();
}

class _UpcomingNotificationListItemState
    extends State<UpcomingNotificationListItem> {
  Future<void> removeData() async {
    CommonDialog.showConfirmDialog(
      context: context,
      titleText: '是否確定刪除？',
      onConfirmPressed: () async {
        try {
          if (widget.notification.model is Advice) {
            await AdvicesService.deleteAdvice(widget.notification.id);
          } else if (widget.notification.model is Drug) {
            await DrugsService.deleteDrug(widget.notification.id);
          } else if (widget.notification.model is Vaccine) {
            await VaccinesService.deleteVaccine(widget.notification.id);
          }
          if (!mounted) return;
          await Provider.of<AppProvider>(context, listen: false).updateMember();
        } catch (e) {
          if (!mounted) return;
          rethrow;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        height: 120,
        child: Card(
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // showModalBottomSheet(
              //   clipBehavior: Clip.antiAlias,
              //   useRootNavigator: true,
              //   isScrollControlled: true,
              //   context: context,
              //   constraints: BoxConstraints(
              //     maxHeight: MediaQuery.of(context).size.height * 0.90,
              //   ),
              //   builder: (BuildContext context) {
              //     return Navigator(
              //       onGenerateRoute: (settings) {
              //         return CupertinoPageRoute(
              //             builder: (context) => const EditNotificationPage());
              //       },
              //     // );
              //   },
              // );
            },
            child: Slidable(
              // 如果 Slidable 可以關閉，需指定一個不重複的 Key
              key: UniqueKey(),

              // 右測滑塊設置
              endActionPane:
                  (widget.notification.petManagement.pmPermissions == '3')
                      ? null
                      : ActionPane(
                          // 寬度比例
                          extentRatio: 0.25,
                          motion: const DrawerMotion(),
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) => removeData(),
                              backgroundColor: UiColor.errorColor,
                              foregroundColor: Colors.white,
                              child: SvgPicture.asset(AssetsImages.deleteSvg),
                            ),
                          ],
                        ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: widget
                                  .notification.petMugShot!.isEmpty
                              ? const AssetImage(AssetsImages.petAvatorPng)
                              : MemoryImage(widget.notification.petMugShot!),
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
                                  size: 16, color: UiColor.theme2Color)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1Color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        RichTextDivider(
                          children: [
                            TextSpan(
                              text: widget.notification.dateTime.formatDate(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: UiColor.text2Color,
                              ),
                            ),
                            TextSpan(
                              text: widget.notification.petName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: UiColor.text2Color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
