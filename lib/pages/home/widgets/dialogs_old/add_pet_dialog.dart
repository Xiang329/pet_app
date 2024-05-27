import 'package:flutter/material.dart';
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
    return AlertDialog(
      backgroundColor: UiColor.theme1_color,
      title: const Center(child: Text("請選擇")),
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
                  title: const Text("新增寵物"),
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
                  title: const Text("加入現有寵物"),
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
                borderRadius: BorderRadius.circular(8),
              ),
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
