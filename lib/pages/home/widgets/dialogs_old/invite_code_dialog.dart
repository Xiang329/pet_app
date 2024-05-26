import 'package:flutter/material.dart';
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
    return AlertDialog(
      backgroundColor: UiColor.theme1_color,
      title: const Center(child: Text("請輸入邀請碼")),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: UiColor.text1_color,
      ),
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: TextFormField(
          controller: codeController,
          textAlign: TextAlign.center,
          style: const TextStyle(color: UiColor.text1_color),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            fillColor: UiColor.textinput_color,
            filled: true,
            border: InputBorder.none,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          height: 36,
          width: 96,
          child: OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(width: 2, color: UiColor.theme2_color),
              ),
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
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              backgroundColor: MaterialStateProperty.all(UiColor.theme2_color),
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
    );
  }
}
