import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/drawer/breeding/edit_my_breeding_page.dart';

class BreedingDetailPage extends StatefulWidget {
  const BreedingDetailPage({super.key});

  @override
  State<BreedingDetailPage> createState() => _BreedingDetailPageState();
}

class _BreedingDetailPageState extends State<BreedingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("寵物資料"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          SizedBox(
            height: 56,
            width: 56,
            child: PopupMenuButton<int>(
              constraints: const BoxConstraints.tightFor(width: 75),
              icon: const Icon(Icons.more_horiz),
              offset: const Offset(0, kToolbarHeight),
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  height: 40,
                  value: 1,
                  child: const Center(
                    child: Text(
                      "編輯",
                      style: TextStyle(
                        color: UiColor.text1_color,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const EditMyBreedingPage(),
                    ));
                  },
                ),
                const PopupMenuDivider(height: 0),
                PopupMenuItem(
                  padding: const EdgeInsets.all(0),
                  height: 40,
                  value: 2,
                  child: const Center(
                    child: Text(
                      "刪除",
                      style: TextStyle(
                        color: UiColor.text1_color,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(AssetsImages.dogJpg),
                ),
              ),
              const SizedBox(height: 20),
              const Card(
                color: UiColor.textinput_color,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "寵物資訊",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: UiColor.text1_color,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: UiColor.text2_color,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "名稱　",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: "寵物名稱",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: UiColor.text2_color,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "類別　",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: "狗",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: UiColor.text2_color,
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "品種　",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: "瑪爾濟斯",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
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
                      SizedBox(height: 5),
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
              ),
              const SizedBox(height: 20),
              const Card(
                color: UiColor.textinput_color,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "聯絡資訊",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: UiColor.text1_color,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "0912345678　陳先生",
                        style: TextStyle(
                          color: UiColor.text2_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
