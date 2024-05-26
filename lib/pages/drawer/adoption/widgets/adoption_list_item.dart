import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/drawer/adoption/adoption_detail.dart';
import 'package:pet_app/widgets/divider_row.dart';

class AdoptionListItem extends StatefulWidget {
  const AdoptionListItem({super.key});

  @override
  State<AdoptionListItem> createState() => _AdoptionListItemState();
}

class _AdoptionListItemState extends State<AdoptionListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdoptionDetailPage(),
              ),
            );
          },
          child: const SizedBox(
            height: 120,
            child: Card(
              color: UiColor.textinput_color,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            color: UiColor.text1_color,
                          ),
                        ),
                        Text(
                          "瑪爾濟斯",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1_color,
                          ),
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
                            text: "收容所　",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "臺北市動物之家",
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
            ),
          ),
        ),
      ),
    );
  }
}
