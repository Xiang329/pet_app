import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/filled_text_field.dart';

class EditMyMissingPage extends StatefulWidget {
  const EditMyMissingPage({super.key});

  @override
  State<EditMyMissingPage> createState() => _EditMyMissingPageState();
}

class _EditMyMissingPageState extends State<EditMyMissingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("編輯遺失資訊"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 375,
                  maxHeight: 375,
                ),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(AssetsImages.dogJpg),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete,
                              size: 15, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Card(
                margin: EdgeInsets.zero,
                color: UiColor.theme1_color,
                shadowColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    FilledTextField(labelText: '寵物名稱'),
                    SizedBox(height: 10),
                    FilledTextField(labelText: '類別'),
                    SizedBox(height: 10),
                    FilledTextField(labelText: '品種'),
                    SizedBox(height: 10),
                    FilledTextField(labelText: '性別'),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17),
                          child: Text(
                            '其他描述',
                            style: TextStyle(
                                color: Color(0xFF593922),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: "內容描述",
                        hintStyle: TextStyle(
                            color: Color(0xFF837266),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 17),
                        fillColor: Color(0xFFF7EFD8),
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    FilledTextField(labelText: '遺失日期'),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17),
                          child: Text(
                            '遺失地點',
                            style: TextStyle(
                                color: Color(0xFF593922),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: "內容描述",
                        hintStyle: TextStyle(
                            color: Color(0xFF837266),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 17),
                        fillColor: Color(0xFFF7EFD8),
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17),
                          child: Text(
                            '聯絡方式',
                            style: TextStyle(
                                color: Color(0xFF593922),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: "內容描述",
                        hintStyle: TextStyle(
                            color: Color(0xFF837266),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 17),
                        fillColor: Color(0xFFF7EFD8),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: UiColor.theme2_color),
                  child: const Text(
                    '確定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
