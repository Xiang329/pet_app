import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/animal.dart';
import 'package:pet_app/utils/date_format_extension.dart';

class AdoptionDetailPage extends StatefulWidget {
  final Animal animal;
  const AdoptionDetailPage({super.key, required this.animal});

  @override
  State<AdoptionDetailPage> createState() => _AdoptionDetailPageState();
}

class _AdoptionDetailPageState extends State<AdoptionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("動物資料"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: UiColor.textinputColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "動物資訊",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1Color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "入所日期　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat('yyyy/MM/dd')
                                    .tryParse(widget.animal.animalCreatetime)
                                    .formatDate(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "是否開放認領養　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.animalOpendate == '- - -'
                                    ? '待認領'
                                    : '適合認養 ( 開放日期：${DateFormat('yyyy-MM-dd').tryParse(widget.animal.animalOpendate).formatDate()} )',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "收容編號　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.animalSubid,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
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
                                text: widget.animal.animalKind,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
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
                                text: widget.animal.animalVariety,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "毛色　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.animalColour,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
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
                                text: widget.animal.animalSex,
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
                          "收容所資訊",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: UiColor.text1Color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "公告收容所　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.shelterName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "收容所電話　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.shelterTel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: UiColor.text2Color,
                          ),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "收容所地址　",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.animal.shelterAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
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
                                text: widget.animal.animalRemark,
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
        ),
      ),
    );
  }
}
