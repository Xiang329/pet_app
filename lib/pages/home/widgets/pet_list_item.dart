import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/pages/home/pet_management_page.dart';
import 'package:pet_app/pages/home/pet_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';
import 'package:provider/provider.dart';

class PetItem extends StatefulWidget {
  final PetManagement petManagement;
  final int petIndex;

  const PetItem({
    super.key,
    required this.petIndex,
    required this.petManagement,
  });

  @override
  State<PetItem> createState() => _PetItemState();
}

class _PetItemState extends State<PetItem> {
  void removeData() async {
    final petManagemnet = Provider.of<AppProvider>(context, listen: false)
        .petManagement[widget.petIndex];
    CommonDialog.showConfirmDialog(
      context: context,
      titleText: '是否確定刪除？',
      onConfirmPressed: () async {
        try {
          await Provider.of<AppProvider>(context, listen: false).deletePet(
            petManagemnet.pmId,
            petManagemnet.pmPetId,
            petManagemnet.pmPermissions,
          );
        } catch (e) {
          rethrow;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final petManagemnet =
        Provider.of<AppProvider>(context).petManagement[widget.petIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        height: 120,
        child: Card(
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Provider.of<AppProvider>(context, listen: false).updateMember();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => PetDetailPage(
                    pmId: widget.petManagement.pmId,
                  ),
                ),
              );
            },
            child: (widget.petManagement.pmPermissions != '3')
                ? Slidable(
                    // 如果 Slidable 可以關閉，需指定一個不重複的 Key
                    key: UniqueKey(),

                    // 右測滑塊設置
                    endActionPane: ActionPane(
                      // 寬度比例
                      extentRatio: 0.4,
                      motion: const DrawerMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PetManagementPage(
                                  petId: petManagemnet.pmPetId,
                                ),
                              ),
                            );
                          },
                          backgroundColor: UiColor.theme2Color,
                          foregroundColor: Colors.white,
                          child: SvgPicture.asset(AssetsImages.managementSvg),
                        ),
                        CustomSlidableAction(
                          onPressed: (context) => removeData(),
                          backgroundColor: UiColor.errorColor,
                          foregroundColor: Colors.white,
                          child: SvgPicture.asset(AssetsImages.deleteSvg),
                        ),
                      ],
                    ),
                    child: petListTile(widget.petManagement.pet!),
                  )
                : petListTile(widget.petManagement.pet!),
          ),
        ),
      ),
    );
  }

  Widget petListTile(Pet pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: pet.petMugShot.isEmpty
                ? const AssetImage(AssetsImages.petAvatorPng)
                : MemoryImage(pet.petMugShot),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pet.petName,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: UiColor.text1Color)),
              Text(
                pet.varietyName,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: UiColor.text2Color),
              ),
              RichTextDivider(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset(pet.petSex
                        ? AssetsImages.maleSvg
                        : AssetsImages.femaleSvg),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(
                    text: "${pet.petAge}歲",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text2Color),
                  ),
                  TextSpan(
                    text: "${pet.petWeight}公斤",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text2Color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
