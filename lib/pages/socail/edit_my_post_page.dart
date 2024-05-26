import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class EditMyPostPage extends StatefulWidget {
  const EditMyPostPage({super.key});

  @override
  State<EditMyPostPage> createState() => _EditMyPostPageState();
}

class _EditMyPostPageState extends State<EditMyPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("編輯貼文"),
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
                  // maxWidth: 375,
                  maxHeight: 375,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: UiColor.textinput_color,
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "內容描述",
                    hintStyle: TextStyle(
                        color: UiColor.text2_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 17),
                    fillColor: UiColor.textinput_color,
                    filled: true,
                  ),
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
