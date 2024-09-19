import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class DropdownList extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? value;
  final double? width;
  final FormFieldValidator? validator;
  const DropdownList({
    super.key,
    required this.title,
    required this.items,
    this.onChanged,
    this.value,
    this.width,
    this.validator,
  });

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  bool _hasError = false;
  bool _hasItems = false;

  @override
  Widget build(BuildContext context) {
    (widget.items.isEmpty) ? _hasItems = false : _hasItems = true;
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownButtonFormField2<String>(
        validator: (value) {
          final errorText = widget.validator?.call(value);
          setState(() {
            _hasError = errorText != null;
          });
          return errorText;
        },
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _hasError ? UiColor.errorColor : UiColor.text2Color,
          ),
          errorStyle: const TextStyle(
            color: UiColor.errorColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              width: widget.value == null ? 1 : 2,
              color: UiColor.navigationBarColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.text1Color),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: UiColor.errorColor),
          ),
        ),
        isExpanded: true,
        items: widget.items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: UiColor.text1Color,
                  ),
                ),
              ),
            )
            .toList(),
        value: widget.value,
        onChanged: widget.onChanged,
        iconStyleData: IconStyleData(
          icon: SvgPicture.asset(
            AssetsImages.arrowDownSvg,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              _hasItems ? UiColor.navigationBarColor : Colors.grey.shade300,
              BlendMode.srcIn,
            ),
          ),
        ),
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
