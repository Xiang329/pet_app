import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/breeding/breeding_detail_page.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';

class BreedingListItem extends StatefulWidget {
  final int breedingId;
  final int petId;
  final Pet pet;
  final bool editable;
  const BreedingListItem({
    super.key,
    required this.editable,
    required this.petId,
    required this.breedingId,
    required this.pet,
  });

  @override
  State<BreedingListItem> createState() => _BreedingListItemState();
}

class _BreedingListItemState extends State<BreedingListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      child: SizedBox(
        height: 120,
        child: Card(
          margin: EdgeInsets.zero,
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => BreedingDetailPage(
                    editable: widget.editable,
                    breedingID: widget.breedingId,
                    petID: widget.petId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.pet.petMugShot.isEmpty
                        ? const AssetImage(AssetsImages.petAvatorPng)
                        : MemoryImage(widget.pet.petMugShot),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichTextDivider(
                          children: [
                            TextSpan(
                              text: widget.pet.className,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1Color),
                            ),
                            TextSpan(
                              text: widget.pet.varietyName,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1Color),
                            ),
                          ],
                        ),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "性別　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.pet.petSex ? "男" : "女",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "年紀　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '${widget.pet.petAge} 歲',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
