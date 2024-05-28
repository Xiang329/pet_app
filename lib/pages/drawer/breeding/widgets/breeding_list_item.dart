import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/drawer/breeding/breeding_detail_page.dart';
import 'package:pet_app/widgets/divider_row.dart';

class BreedingListItem extends StatefulWidget {
  const BreedingListItem({super.key});

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
          color: UiColor.textinput_color,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BreedingDetailPage(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
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
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1_color),
                            ),
                            Text(
                              "瑪爾濟斯",
                              overflow: TextOverflow.ellipsis,
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
                                text: "性別　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "公",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
                                text: "年紀　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "5歲",
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
