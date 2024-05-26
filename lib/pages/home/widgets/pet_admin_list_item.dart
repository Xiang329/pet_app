import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/pet_admin.dart';
import 'package:pet_app/providers/pet_admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class PetAdminItem extends StatefulWidget {
  final PetAdmin admin;
  const PetAdminItem({super.key, required this.admin});

  @override
  State<PetAdminItem> createState() => _PetAdminItemState();
}

class _PetAdminItemState extends State<PetAdminItem> {
  // 必須確保更新狀態，否則出錯 A dismissed Slidable widget is still part of the tree.
  // 只需在回調中移除相應的 Pet 對象
  void removeData() {
    Provider.of<PetAdminsProvider>(context, listen: false)
        .removePetAdmin(widget.admin);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Center(child: Text('共同管理人 ${widget.admin.name} 刪除成功')),
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
          clipBehavior: Clip.antiAlias,
          color: UiColor.textinput_color,
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
            child: petAdminListTile(widget.admin),
          ),
        ),
      ),
    );
  }

  Widget petAdminListTile(PetAdmin admin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(AssetsImages.dogJpg),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(admin.name,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: UiColor.text1_color)),
                const SizedBox(height: 5),
                CustomSlidingSegmentedControl<int>(
                  initialValue: admin.access,
                  height: 34,
                  isStretch: true,
                  innerPadding: const EdgeInsets.all(6.0),
                  children: const {
                    1: Text('僅查看',
                        style: TextStyle(
                            fontSize: 13, color: UiColor.text1_color)),
                    2: Text('查看及編輯',
                        style: TextStyle(
                            fontSize: 13, color: UiColor.text1_color)),
                  },
                  decoration: BoxDecoration(
                    color: UiColor.theme1_color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: UiColor.theme2_color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  duration: const Duration(milliseconds: 400),
                  // 動畫過渡曲線
                  // curve: Curves.easeInOutCubic,
                  onValueChanged: (v) {
                    print(v);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
