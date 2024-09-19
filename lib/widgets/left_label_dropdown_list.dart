import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';

class LeftLabelDropdownList extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? value;
  final double? width;
  final FormFieldValidator? validator;
  final bool enableSearch;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  const LeftLabelDropdownList({
    super.key,
    required this.title,
    required this.items,
    this.onChanged,
    this.value,
    this.width,
    this.validator,
    this.enableSearch = false,
    this.topRightRadius = 0,
    this.topLeftRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
  });

  @override
  State<LeftLabelDropdownList> createState() => _LeftLabelDropdownListState();
}

class _LeftLabelDropdownListState extends State<LeftLabelDropdownList> {
  TextEditingController searchController = TextEditingController();
  bool _hasItems = false;

  @override
  Widget build(BuildContext context) {
    (widget.items.isEmpty) ? _hasItems = false : _hasItems = true;
    return LayoutBuilder(builder: (context, constraints) {
      return Builder(builder: (context) {
        return DropdownButtonFormField2<String>(
          validator: widget.validator,
          customButton: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.value ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: UiColor.text2Color,
                      ),
                    ),
                  ),
                ),
                WidgetSpan(
                  child: SvgPicture.asset(
                    AssetsImages.arrowDownSvg,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      _hasItems
                          ? UiColor.navigationBarColor
                          : Colors.grey.shade300,
                      BlendMode.srcIn,
                    ),
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
              ],
            ),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: UiColor.text1Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: UiColor.textinputColor,
            errorStyle: const TextStyle(
              color: UiColor.errorColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.topLeftRadius),
                topRight: Radius.circular(widget.topRightRadius),
                bottomLeft: Radius.circular(widget.bottomLeftRadius),
                bottomRight: Radius.circular(widget.bottomRightRadius),
              ),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          items: widget.items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: UiColor.text1Color,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          value: widget.value,
          onChanged: widget.onChanged,
          dropdownStyleData: DropdownStyleData(
            // *Bug? 元件有內建的額外Padding
            // 在InputDecoration使用label，導致選擇item後會有與label邊界不一樣的問題
            // 原因:使用contentPadding會包住元件內的Padding
            // 解決方法:在DropdownStyleData設定width可解決
            width: constraints.maxWidth,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: UiColor.textinputColor,
            ),
          ),
          dropdownSearchData: !widget.enableSearch
              ? null
              : DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidgetHeight: 100,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: OutlinedTextField(
                      controller: searchController,
                      hintText: '搜尋',
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  },
                ),
          // 關閉選單時清除搜尋值
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
        );
      });
    });
  }
}
