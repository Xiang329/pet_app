import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class AddPetDialog extends StatefulWidget {
  const AddPetDialog({
    super.key,
  });

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: IntrinsicWidth(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              // 耳朵高度
              top: -35,
              bottom: 0,
              right: 0,
              left: 0,
              child: SvgPicture.asset(AssetsImages.dialogSvg),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "請選擇",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: UiColor.text1_color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        IntrinsicWidth(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              listTileTheme: const ListTileThemeData(
                                  horizontalTitleGap: 0),
                            ),
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                "新增寵物",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              value: 1,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  print("選擇的值: $value");
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              listTileTheme: const ListTileThemeData(
                                  horizontalTitleGap: 0),
                            ),
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                "加入現有寵物",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: UiColor.text2_color,
                                ),
                              ),
                              value: 2,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  print("選擇的值: $value");
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 36,
                        width: 96,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(
                                width: 2, color: UiColor.theme2_color),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: UiColor.theme2_color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        width: 96,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: UiColor.theme2_color,
                          ),
                          child: const Text(
                            '確定',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: UiColor.theme1_color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(selectedOption);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
