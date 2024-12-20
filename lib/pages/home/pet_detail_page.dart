import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/model/pet_management.dart';
import 'package:pet_app/pages/home/edit_pet_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:pet_app/widgets/empty_data.dart';
import 'package:pet_app/widgets/rich_text_divider.dart';
import 'package:pet_app/pages/home/widgets/notification_and_record_panel.dart';
import 'package:pet_app/pages/home/widgets/underline_text.dart';
import 'package:provider/provider.dart';

class PetDetailPage extends StatefulWidget {
  final int pmId;
  const PetDetailPage({
    super.key,
    required this.pmId,
  });

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  @override
  Widget build(BuildContext context) {
    PetManagement? petManagemnet;
    Pet? pet;
    bool editable = false;
    final appProvider = Provider.of<AppProvider>(context);
    petManagemnet = appProvider.petManagement
        .firstWhereOrNull((petManagement) => petManagement.pmId == widget.pmId);
    if (petManagemnet != null) {
      pet = petManagemnet.pet;
      editable = petManagemnet.pmPermissions != '3';
    }
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text('我的寵物'),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (petManagemnet == null || pet == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('錯誤'),
                    content: const Text('這隻寵物溜走啦。'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('確定'),
                        onPressed: () {
                          if (!context.mounted) return;
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
            return const Center(child: EmptyData());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: Card(
                    color: UiColor.textinputColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: pet.petMugShot.isEmpty
                                        ? const AssetImage(
                                            AssetsImages.petAvatorPng)
                                        : MemoryImage(pet.petMugShot),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          alignment:
                                              PlaceholderAlignment.middle,
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
                                    UnderLineText(
                                        '生日　${pet.petBirthDay.formatDate()}'),
                                    UnderLineText(
                                        '結紮　${pet.petLigation ? "是" : "否"}'),
                                    UnderLineText('血型　${pet.petBlood}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: PopupMenuButton<int>(
                              constraints:
                                  const BoxConstraints.tightFor(width: 75),
                              icon: SvgPicture.asset(AssetsImages.optionSvg),
                              offset: const Offset(0, 40),
                              color: Colors.white,
                              surfaceTintColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                              itemBuilder: (context) => [
                                if (editable) ...[
                                  PopupMenuItem(
                                    padding: const EdgeInsets.all(0),
                                    height: 40,
                                    value: 1,
                                    child: const Center(
                                      child: Text(
                                        "編輯",
                                        style: TextStyle(
                                          color: UiColor.text1Color,
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
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.90,
                                        ),
                                        builder: (BuildContext context) {
                                          return Navigator(
                                            onGenerateRoute: (settings) {
                                              return CupertinoPageRoute(
                                                  builder: (context) =>
                                                      EditPetPage(
                                                        pet: pet!,
                                                        pmId: widget.pmId,
                                                      ));
                                            },
                                          );
                                        },
                                      ).then((value) => setState(() {}));
                                    },
                                  ),
                                  const PopupMenuDivider(height: 0),
                                ],
                                PopupMenuItem(
                                  padding: const EdgeInsets.all(0),
                                  height: 40,
                                  value: 2,
                                  child: const Center(
                                    child: Text(
                                      "刪除",
                                      style: TextStyle(
                                        color: UiColor.text1Color,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    CommonDialog.showConfirmDialog(
                                      context: context,
                                      titleText: '是否確定刪除？',
                                      onConfirmPressed: () async {
                                        try {
                                          if (!context.mounted) return;
                                          await Provider.of<AppProvider>(
                                                  context,
                                                  listen: false)
                                              .deletePet(
                                            petManagemnet!.pmId,
                                            petManagemnet.pmPetId,
                                            petManagemnet.pmPermissions,
                                          );
                                          if (!context.mounted) return;
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        } catch (e) {
                                          rethrow;
                                        }
                                      },
                                    );
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
                      color: UiColor.text1Color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                NotificationAndRecordPanel(pmId: widget.pmId),
              ],
            ),
          );
        },
      ),
    );
  }
}
