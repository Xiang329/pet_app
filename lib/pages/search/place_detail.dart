import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/hospital.dart';
import 'package:pet_app/models/shop.dart';
import 'package:flutter/material.dart';

class PlaceDetailPage extends StatefulWidget {
  final Hospital? hospital;
  final Shop? shop;
  const PlaceDetailPage({super.key, this.hospital, this.shop});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: widget.hospital != null ? const Text('找醫院') : const Text('找商店'),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
          color: UiColor.theme1_color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
                child: Card(
                  color: UiColor.textinput_color,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '好狗運貓狗福利中心',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1_color,
                                ),
                              ),
                              Text(
                                '地址 241新北市三重區中正北路510號',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '電話 0229821666',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '評價 4.6 (208)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
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
              const SizedBox(height: 20),
              const SizedBox(
                height: 260,
                child: Card(
                  color: UiColor.textinput_color,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '營業時間',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text1_color,
                                ),
                              ),
                              Text(
                                '星期一 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期二 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期三 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期四 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期五 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期六 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              Text(
                                '星期日 11:00 - 22:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: UiColor.text2_color,
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
              const SizedBox(height: 20),
              Card(
                color: UiColor.textinput_color,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  alignment: Alignment.center,
                  constraints:
                      const BoxConstraints(maxWidth: 620, maxHeight: 400),
                  child: Image.asset(
                    AssetsImages.mapJpg,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
