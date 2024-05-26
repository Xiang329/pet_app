import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class DropdownList extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? value;
  final double? width;
  const DropdownList({
    super.key,
    required this.title,
    required this.items,
    this.onChanged,
    this.value,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownButtonFormField2<String>(
        decoration: InputDecoration(
          label: Text(title),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: UiColor.text2_color,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.navigationBar_color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.text1_color),
          ),
        ),
        isExpanded: true,
        items: items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: UiColor.text1_color,
                  ),
                ),
              ),
            )
            .toList(),
        value: value,
        onChanged: onChanged,
        // 保留
        // buttonStyleData: const ButtonStyleData(
        //   padding: EdgeInsets.only(left: 0),
        //   height: 20,
        //   width: 140,
        // ),
        // 保留
        // menuItemStyleData: const MenuItemStyleData(
        //   height: 40,
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        // ),
        dropdownStyleData: DropdownStyleData(
          // *Bug? 元件有內建的額外Padding
          // 在InputDecoration使用label，導致選擇item後會有與label邊界不一樣的問題
          // 原因:使用contentPadding會包住元件內的Padding
          // 解決方法:在DropdownStyleData設定width可解決
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    });
  }
}
