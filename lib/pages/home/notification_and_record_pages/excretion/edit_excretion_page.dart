import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/filled_text_field.dart';

class EditExcretionPage extends StatefulWidget {
  const EditExcretionPage({super.key});

  @override
  State<EditExcretionPage> createState() => _EditExcretionPageState();
}

class _EditExcretionPageState extends State<EditExcretionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("排泄紀錄"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Card(
                      color: UiColor.theme1_color,
                      shadowColor: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const FilledTextField(
                            labelText: '排泄日期',
                            hintText: '日期',
                          ),
                          const SizedBox(height: 25),
                          const FilledTextField(
                            readOnly: true,
                            labelText: '排泄時間',
                            hintText: '時間',
                          ),
                          const SizedBox(height: 25),
                          const FilledTextField(
                            maxLines: 4,
                            labelText: '排泄情況',
                            hintText: '情況',
                          ),
                          const SizedBox(height: 25),
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 42,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: UiColor.theme2_color),
                    child: const Text(
                      '完成',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
