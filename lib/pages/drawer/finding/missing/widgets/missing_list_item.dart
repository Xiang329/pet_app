import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/finding/missing/missing_detail_page.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';

class MissingListItem extends StatefulWidget {
  final Finding finding;
  final Pet pet;
  final bool editable;
  const MissingListItem({
    super.key,
    required this.finding,
    required this.pet,
    required this.editable,
  });

  @override
  State<MissingListItem> createState() => _MissingListItemState();
}

class _MissingListItemState extends State<MissingListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      child: SizedBox(
        // height: 140,
        child: Card(
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MissingDetailPage(
                    editable: widget.editable,
                    findingId: widget.finding.findingId,
                    petId: widget.finding.findingPetId!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "遺失日期　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.finding.findingDateTime.formatDate(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "遺失地點　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.finding.findingPlace,
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
