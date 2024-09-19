import 'package:flutter/cupertino.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/pages/drawer/finding/found/found_detail_page.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';

class FoundListItem extends StatefulWidget {
  final Finding finding;
  final bool editable;
  const FoundListItem({
    super.key,
    required this.finding,
    required this.editable,
  });

  @override
  State<FoundListItem> createState() => _FoundListItemState();
}

class _FoundListItemState extends State<FoundListItem> {
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
                  builder: (context) => FoundDetailPage(
                    editable: widget.editable,
                    findingId: widget.finding.findingId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.finding.findingImage.isEmpty
                        ? const AssetImage(AssetsImages.petAvatorPng)
                        : MemoryImage(widget.finding.findingImage),
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
                              text: widget.finding.className,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: UiColor.text1Color,
                              ),
                            ),
                            TextSpan(
                              text: widget.finding.varietyName,
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
                                text: "拾獲日期　",
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
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "拾獲地點　",
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
