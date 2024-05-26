import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class InviteCodeDialog extends StatefulWidget {
  const InviteCodeDialog({
    super.key,
  });

  @override
  State<InviteCodeDialog> createState() => _InviteCodeDialogState();
}

class _InviteCodeDialogState extends State<InviteCodeDialog> {
  TextEditingController codeController = TextEditingController();
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
                    "請輸入邀請碼",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: UiColor.text1_color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    clipBehavior: Clip.antiAlias,
                    child: TextFormField(
                      controller: codeController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: UiColor.text1_color),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        fillColor: UiColor.textinput_color,
                        filled: true,
                        border: InputBorder.none,
                      ),
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
                                borderRadius: BorderRadius.circular(8)),
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
                      const SizedBox(width: 20),
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
                            '加入',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: UiColor.theme1_color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(codeController.text);
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
