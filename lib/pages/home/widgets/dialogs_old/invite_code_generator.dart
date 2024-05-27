import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class InviteCodeGeneratorDialog extends StatefulWidget {
  const InviteCodeGeneratorDialog({
    super.key,
  });

  @override
  State<InviteCodeGeneratorDialog> createState() =>
      _InviteCodeGeneratorDialogState();
}

class _InviteCodeGeneratorDialogState extends State<InviteCodeGeneratorDialog> {
  TextEditingController codeController = TextEditingController();
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    codeController.text = '123456789';
    return AlertDialog(
      backgroundColor: UiColor.theme1_color,
      title: const Center(child: Text("Pudding的邀請碼是")),
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
          readOnly: true,
          controller: codeController,
          textAlign: TextAlign.center,
          style: const TextStyle(color: UiColor.text1_color),
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {},
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
              Navigator.of(context).pop(codeController.text);
            },
          ),
        ),
      ],
    );
  }
}
