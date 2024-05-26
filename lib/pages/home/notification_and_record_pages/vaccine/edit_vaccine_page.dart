import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/filled_text_field.dart';

class EditVaccinePage extends StatefulWidget {
  const EditVaccinePage({super.key});

  @override
  State<EditVaccinePage> createState() => _EditVaccinePageState();
}

class _EditVaccinePageState extends State<EditVaccinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("疫苗紀錄"),
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
                const Column(
                  children: [
                    Card(
                      color: UiColor.theme1_color,
                      shadowColor: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledTextField(
                            labelText: '疫苗名稱',
                            hintText: '名稱',
                          ),
                          SizedBox(height: 25),
                          FilledTextField(
                            readOnly: true,
                            labelText: '施打日期',
                            hintText: '日期',
                          ),
                          SizedBox(height: 25),
                          FilledTextField(
                            readOnly: true,
                            labelText: '下次施打日期',
                            hintText: '時間',
                          ),
                          SizedBox(height: 25),
                          FilledTextField(
                            labelText: '是否過敏',
                            hintText: '否',
                          ),
                          SizedBox(height: 25),
                          FilledTextField(
                            maxLines: 4,
                            labelText: '過敏症狀',
                            hintText: '過敏症狀',
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
