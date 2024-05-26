import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';

class AddVaccinePage extends StatefulWidget {
  const AddVaccinePage({super.key});

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("新增疫苗紀錄"),
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
                    OutlinedTextField(
                      labelText: '疫苗名稱',
                      hintText: '疫苗名稱',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '施打日期',
                      hintText: '日期',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '下次施打日期',
                      hintText: '日期',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '是否過敏',
                      hintText: '',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '過敏症狀',
                      hintText: '過敏症狀',
                      maxLines: 4,
                      alignLabelWithHint: true,
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
