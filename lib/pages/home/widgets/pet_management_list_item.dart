import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/widgets/common_dialog.dart';

class PetManagementListItem extends StatefulWidget {
  final PetManagement coManager;
  final bool editable;
  final VoidCallback reloadPage;
  const PetManagementListItem({
    super.key,
    required this.coManager,
    required this.editable,
    required this.reloadPage,
  });

  @override
  State<PetManagementListItem> createState() => _PetManagementListItemState();
}

class _PetManagementListItemState extends State<PetManagementListItem> {
  void removeData() {
    CommonDialog.showConfirmDialog(
      context: context,
      titleText: '是否確定刪除？',
      onConfirmPressed: () async {
        try {
          await PetManagementsService.deletePetManagement(
              widget.coManager.pmId);
          widget.reloadPage();
          const snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Center(child: Text('共同管理人刪除成功')),
            duration: Duration(seconds: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } catch (e) {
          rethrow;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int access = int.parse(widget.coManager.pmPermissions);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 120,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: UiColor.textinputColor,
          child: Slidable(
            // 如果 Slidable 可以關閉，需指定一個不重複的 Key
            key: UniqueKey(),

            // 右測滑塊設置
            endActionPane: widget.editable
                ? ActionPane(
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
                  )
                : null,
            child: petAdminListTile(widget.coManager, access, widget.editable),
          ),
        ),
      ),
    );
  }

  Widget petAdminListTile(PetManagement coManager, int access, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: coManager.member!.memberMugShot.isEmpty
                ? const AssetImage(AssetsImages.userAvatorPng)
                : MemoryImage(coManager.member!.memberMugShot),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(coManager.member!.memberName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: UiColor.text1Color,
                    )),
                const SizedBox(height: 5),
                AbsorbPointer(
                  absorbing: !editable,
                  child: CustomSlidingSegmentedControl<int>(
                    initialValue: access,
                    height: 34,
                    isStretch: true,
                    innerPadding: const EdgeInsets.all(6.0),
                    children: const {
                      3: Text('僅查看',
                          style: TextStyle(
                              fontSize: 13, color: UiColor.text1Color)),
                      2: Text('查看及編輯',
                          style: TextStyle(
                              fontSize: 13, color: UiColor.text1Color)),
                    },
                    decoration: BoxDecoration(
                      color: UiColor.theme1Color,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    thumbDecoration: BoxDecoration(
                      color: UiColor.theme2Color,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    duration: const Duration(milliseconds: 400),
                    // 動畫過渡曲線
                    // curve: Curves.easeInOutCubic,
                    onValueChanged: (value) async {
                      final petManagementData = {
                        "PM_ID": coManager.pmId,
                        "PM_MemberID": coManager.member!.memberId,
                        "PM_PetID": coManager.pmPetId,
                        "PM_Permissions": value,
                      };
                      print(petManagementData);
                      await PetManagementsService.updatePetManagement(
                          coManager.pmId, petManagementData);
                      widget.reloadPage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
