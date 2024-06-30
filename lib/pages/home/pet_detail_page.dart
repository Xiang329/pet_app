import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/pages/home/edit_pet_page.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:pet_app/widgets/divider_row.dart';
import 'package:pet_app/pages/home/widgets/notification_and_record_panel.dart';
import 'package:pet_app/pages/home/widgets/underline_text.dart';
import 'package:provider/provider.dart';

class PetDetailPage extends StatefulWidget {
  final int petIndex;
  const PetDetailPage({super.key, required this.petIndex});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  @override
  Widget build(BuildContext context) {
    final pet = Provider.of<MemberProvider>(context, listen: false)
        .pets![widget.petIndex];

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text('我的寵物'),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Card(
                color: UiColor.textinput_color,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage(AssetsImages.dogJpg),
                              ),
                            ],
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                DividerRow(
                                  children: [
                                    Text(
                                      pet.sex ? "男" : "女",
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: UiColor.text2_color,
                                      ),
                                    ),
                                    Text(
                                      "${pet.age}歲",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: UiColor.text2_color,
                                      ),
                                    ),
                                    Text(
                                      "${pet.weight}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: UiColor.text2_color,
                                      ),
                                    ),
                                  ],
                                ),
                                UnderLineText(
                                    '生日  ${DateFormat('yyyy年MM月dd日').format(pet.birthDay)}'),
                                UnderLineText(
                                    '結紮  ${pet.ligation ? "男" : "女"}'),
                                UnderLineText('血型  ${pet.blood}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: PopupMenuButton<int>(
                          constraints: const BoxConstraints.tightFor(width: 75),
                          icon: const Icon(Icons.more_horiz),
                          offset: const Offset(0, 40),
                          color: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
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
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAlias,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  context: context,
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.90,
                                  ),
                                  builder: (BuildContext context) {
                                    return Navigator(
                                      onGenerateRoute: (settings) {
                                        return CupertinoPageRoute(
                                            builder: (context) =>
                                                EditPetPage(pet: pet));
                                      },
                                    );
                                  },
                                ).then((value) => setState(() {}));
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
                              onTap: () {
                                Provider.of<MemberProvider>(context,
                                        listen: false)
                                    .deletePet(pet.pmid, pet.id);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "通知及紀錄",
              style: TextStyle(
                  color: UiColor.text1_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const NotificationAndRecordPanel(),
          ],
        ),
      ),
    );
  }
}
