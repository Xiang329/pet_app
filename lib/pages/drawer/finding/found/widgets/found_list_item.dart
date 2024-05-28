import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/drawer/finding/found/found_detail_page.dart';
import 'package:pet_app/widgets/divider_row.dart';

class FoundListItem extends StatefulWidget {
  const FoundListItem({super.key});

  @override
  State<FoundListItem> createState() => _FoundListItemState();
}

class _FoundListItemState extends State<FoundListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      child: SizedBox(
        height: 140,
        child: Card(
          color: UiColor.textinput_color,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoundDetailPage(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AssetsImages.dogJpg),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DividerRow(
                          children: [
                            Text(
                              "狗",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1_color),
                            ),
                            Text(
                              "瑪爾濟斯",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1_color),
                            ),
                          ],
                        ),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2_color,
                          ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "拾獲日期　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "2024年4月20日",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2_color,
                          ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "拾獲地點　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "新北市三重區重陽路一段20巷4號",
                                style: TextStyle(
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
