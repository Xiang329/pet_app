import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';

class SelectPetItem extends StatefulWidget {
  final Pet pet;
  final int petIndex;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectPetItem({
    super.key,
    required this.pet,
    required this.petIndex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectPetItem> createState() => _SelectPetItemState();
}

class _SelectPetItemState extends State<SelectPetItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 120,
        child: Card(
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color:
                  widget.isSelected ? UiColor.theme2Color : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: petListTile(widget.pet),
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
        Column(
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
                    color: UiColor.text2Color,
                  ),
                ),
                TextSpan(
                  text: "${pet.petWeight} 公斤",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: UiColor.text2Color,
                  ),
                ),
              ],
            ),
            // IntrinsicHeight(
            //   child: Row(
            //     children: [
            //       Text(
            //         pet.petSex ? "男" : "女",
            //         style: const TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //             color: UiColor.text2Color),
            //       ),
            //       const VerticalDivider(
            //         thickness: 1,
            //         width: 26,
            //         color: UiColor.text2Color,
            //       ),
            //       Text(
            //         "${pet.petAge}歲",
            //         style: const TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //             color: UiColor.text2Color),
            //       ),
            //       const VerticalDivider(
            //         thickness: 1,
            //         width: 26,
            //         color: UiColor.text2Color,
            //       ),
            //       Text(
            //         "${pet.petWeight}公斤",
            //         style: const TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //             color: UiColor.text2Color),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
