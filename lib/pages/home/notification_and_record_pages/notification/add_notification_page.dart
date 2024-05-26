import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';

class AddNotificationPage extends StatefulWidget {
  const AddNotificationPage({super.key});

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("新增通知"),
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
                      labelText: '事項主題',
                      hintText: '事項主題',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '事項日期',
                      hintText: '事項日期',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '事項日期',
                      hintText: '事項日期',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '事項地點',
                      hintText: '事項地點',
                    ),
                    SizedBox(height: 24),
                    OutlinedTextField(
                      labelText: '事項地點',
                      hintText: '事項地點',
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
