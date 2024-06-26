import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/member.dart';
import 'package:pet_app/pages/home/pet_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PetItem extends StatefulWidget {
  final Pet pet;
  final int petIndex;
  // final VoidCallback onDismissed; // 添加回調函數
  // const PetItem({super.key, required this.pet, required this.onDismissed});
  const PetItem({super.key, required this.pet, required this.petIndex});

  @override
  State<PetItem> createState() => _PetItemState();
}

class _PetItemState extends State<PetItem> {
  // 必須確保更新狀態，否則出錯 A dismissed Slidable widget is still part of the tree.
  // 只需在回調中移除相應的 Pet 對象
  void removeData() {
    // widget.onDismissed();
    // Provider.of<PetsProvider>(context, listen: false).removePet(widget.pet);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Center(child: Text('寵物 ${widget.pet.name} 刪除成功')),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailPage(
                    petIndex: widget.petIndex,
                  ),
                ),
              );
            },
            child: Slidable(
              // 如果 Slidable 可以關閉，需指定一個不重複的 Key
              key: UniqueKey(),

              // 右測滑塊設置
              endActionPane: ActionPane(
                // 寬度比例
                extentRatio: 0.4,
                dismissible: DismissiblePane(onDismissed: () {
                  removeData();
                }),
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Navigator.pushNamed(context, '/access_control_page');
                    },
                    backgroundColor: UiColor.theme2_color,
                    foregroundColor: Colors.white,
                    icon: Icons.account_circle,
                  ),
                  SlidableAction(
                    onPressed: (context) => removeData(),
                    backgroundColor: const Color(0xffe35050),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: petListTile(widget.pet),
            ),
          ),
        ),
      ),
    );
  }

  Widget petListTile(Pet pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(AssetsImages.dogJpg),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(pet.name,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: UiColor.text1_color)),
            Text(
              pet.varietyName,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: UiColor.text2_color),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    pet.sex ? "男" : "女",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text2_color),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 26,
                    color: UiColor.text2_color,
                  ),
                  Text(
                    "${pet.age}歲",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text2_color),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 26,
                    color: UiColor.text2_color,
                  ),
                  Text(
                    "${pet.weight}公斤",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text2_color),
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
