import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/member.dart';
import 'package:pet_app/pages/home/pet_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:provider/provider.dart';

class PetItem extends StatefulWidget {
  final Pet pet;
  final int petIndex;

  const PetItem({super.key, required this.pet, required this.petIndex});

  @override
  State<PetItem> createState() => _PetItemState();
}

class _PetItemState extends State<PetItem> {
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
                  Provider.of<MemberProvider>(context, listen: false)
                      .deletePet(widget.pet.pmid, widget.pet.id);
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
                    onPressed: (context) {
                      Provider.of<MemberProvider>(context, listen: false)
                          .deletePet(widget.pet.pmid, widget.pet.id);
                    },
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
