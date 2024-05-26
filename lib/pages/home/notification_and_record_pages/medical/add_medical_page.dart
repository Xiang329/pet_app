import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';

class AddMedicalPage extends StatefulWidget {
  const AddMedicalPage({super.key});

  @override
  State<AddMedicalPage> createState() => _AddMedicalPageState();
}

class _AddMedicalPageState extends State<AddMedicalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("新增就醫紀錄"),
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
                      labelText: '看診診所',
                      hintText: '看診診所',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '看診日期',
                      hintText: '看診日期',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '疾病或症狀',
                      hintText: '疾病或症狀',
                    ),
                    SizedBox(height: 24),
                    const OutlinedTextField(
                      labelText: '醫囑',
                      hintText: '醫囑',
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
