import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({
    super.key,
  });

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  int selectedOption = 1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: UiColor.theme1_color,
      title: const Center(child: Text("選擇邀請接收者的權限")),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: UiColor.text1_color,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("僅查看"),
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
              Expanded(
                child: RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("查看及編輯"),
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
            ],
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          height: 36,
          width: 96,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              side: const BorderSide(
                width: 2,
                color: UiColor.theme2_color,
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
    );
  }
}
