import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/pages/drawer/finding/missing/edit_my_missing_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/findings_service.dart';
import 'package:pet_app/services/pets_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:provider/provider.dart';

class MissingDetailPage extends StatefulWidget {
  final bool editable;
  final int findingId;
  final int petId;
  const MissingDetailPage({
    super.key,
    required this.editable,
    required this.findingId,
    required this.petId,
  });

  @override
  State<MissingDetailPage> createState() => _MissingDetailPageState();
}

class _MissingDetailPageState extends State<MissingDetailPage> {
  late Finding finding;
  late Pet pet;
  late Future _loadData;

  @override
  void initState() {
    super.initState();
    _loadData = loadData();
  }

  Future loadData() async {
    try {
      finding = await FindingsService.getFindingById(widget.findingId);
      pet = await PetsService.getPetById(widget.petId);
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('錯誤'),
            content: Text(e.toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("遺失資訊"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: !widget.editable
            ? []
            : [
                FutureBuilder(
                  future: _loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Container();
                      }
                      return SizedBox(
                        height: kToolbarHeight,
                        width: kToolbarHeight,
                        child: PopupMenuButton<int>(
                          constraints: const BoxConstraints.tightFor(width: 75),
                          icon: SvgPicture.asset(AssetsImages.optionSvg),
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
                                    color: UiColor.text1Color,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(CupertinoPageRoute<bool>(
                                  builder: (BuildContext context) =>
                                      EditMyMissingPage(
                                    finding: finding,
                                    pet: pet,
                                  ),
                                ))
                                    .then((value) {
                                  if (value == true) {
                                    setState(() {
                                      _loadData = loadData();
                                    });
                                  }
                                });
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
                                    color: UiColor.text1Color,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                try {
                                  await Provider.of<AppProvider>(context,
                                          listen: false)
                                      .deletePetFinding(widget.findingId);
                                  if (!context.mounted) return;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                } catch (e) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('錯誤'),
                                        content: Text(e.toString()),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text('確定'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
      ),
      body: FutureBuilder(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 250),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: pet.petMugShot.isEmpty
                            ? Image.asset(AssetsImages.petPhotoPng)
                            : Image.memory(pet.petMugShot),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: UiColor.textinputColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "寵物資訊",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: UiColor.text1Color,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "名稱　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: pet.petName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "類別　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: pet.className,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "品種　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: pet.varietyName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
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
                                    text: pet.petSex ? '男' : '女',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "描述　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: finding.findingContent,
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
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: UiColor.textinputColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "遺失資訊",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: UiColor.text1Color,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "日期　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: finding.findingDateTime.formatDate(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "地點　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: finding.findingPlace,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: UiColor.text2Color,
                              ),
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "聯絡方式　",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: finding.findingMobile ?? '未提供',
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
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
