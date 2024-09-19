import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class FilterField extends StatefulWidget {
  final Widget filterPage;
  final EdgeInsetsGeometry? margin;
  /// Appbar 專用
  final bool useHorizontalScroll;

  /// 根據篩選列數調整彈窗高度比例
  final int maxHeight;
  final Function(Map<String, String>)? onFilterApplied;
  const FilterField({
    super.key,
    required this.filterPage,
    this.margin = const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    this.useHorizontalScroll = false,
    this.onFilterApplied,
    this.maxHeight = 4,
  });

  @override
  State<FilterField> createState() => FilterFieldState();
}

class FilterFieldState extends State<FilterField> {
  List<String> selectedFilters = [];
  // List selectedFilters = [];
  Map<String, String> selectedMap = {};

  double _getHeight(int value) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxAllowedHeight = screenHeight * .65;
    int setValue = value;
    // 四個級距高度
    Map<int, double> heightOptions = {
      // Body佔用高+AppBar高
      1: 155 + 56,
      2: 228 + 56,
      3: 301 + 56,
      4: 374 + 56,
    };

    double height = heightOptions[value]!;

    // 限制高度不超過容許比例
    while ((height > maxAllowedHeight)) {
      setValue -= 1;
      height = heightOptions[setValue]!;
      if ((setValue == 1)) break;
    }
    return height;
  }

  void _openFilterDialog() {
    final Future selectedFilter = showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(maxHeight: _getHeight(widget.maxHeight)),
      builder: (BuildContext context) {
        return widget.filterPage;
      },
      // builder: (BuildContext context) {
      //   return Navigator(
      //     onGenerateRoute: (settings) {
      //       return CupertinoPageRoute(
      //           builder: (context) => widget.filterPage, settings: settings);
      //     },
      //   );
      // },
    );
    // 新增 Filter
    selectedFilter.then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          selectedFilters = [];
          selectedMap = value;
          widget.onFilterApplied!(selectedMap);
          selectedFilters.addAll(selectedMap.values.toList());
        });
      }
    });
  }

  void _removeFilter(int index) {
    setState(() {
      final key = selectedMap.keys.elementAt(index);
      selectedFilters.removeAt(index);
      selectedMap.remove(key);
      widget.onFilterApplied!(selectedMap);
    });
  }

  void clearFilters() {
    setState(() {
      selectedFilters.clear();
      selectedMap.clear();
      widget.onFilterApplied!({});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFilterDialog,
      child: Container(
        height: widget.useHorizontalScroll ? 40 : null,
        margin: widget.margin,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: UiColor.textinputColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AssetsImages.filterSvg),
              const VerticalDivider(
                width: 20,
                color: UiColor.text1Color,
              ),
              Visibility(
                visible: selectedFilters.isEmpty,
                child: const Text(
                  '篩選',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: UiColor.text1Color,
                  ),
                ),
              ),
              Expanded(
                child: widget.useHorizontalScroll
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedFilters.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CustomChip(
                          text: selectedFilters[index],
                          onDeleted: () => _removeFilter(index),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(width: 8),
                      )
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List.generate(
                          selectedFilters.length,
                          (index) => CustomChip(
                            text: selectedFilters[index],
                            onDeleted: () => _removeFilter(index),
                          ),
                        ),
                      ),

                // 棄用，默認元件 Chip 限制多 不同平台尺寸不一
                // children: List.generate(
                //   selectedFilters.length,
                //   (index) => Chip(
                //     side: BorderSide.none,
                //     backgroundColor: UiColor.theme2Color,
                //     // padding: EdgeInsets.zero,
                //     // labelPadding: const EdgeInsets.fromLTRB(10, -3, 0, -3),
                //     shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(20))),
                //     label: Text(selectedFilters[index]),
                //     labelStyle: const TextStyle(
                //       fontWeight: FontWeight.w600,
                //       color: UiColor.textinputColor,
                //     ),
                //     deleteIconColor: UiColor.textinputColor,
                //     onDeleted: () => _removeFilter(index),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String text;
  final double hight;
  final void Function()? onDeleted;

  const CustomChip({
    super.key,
    required this.text,
    this.onDeleted,
    this.hight = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: UiColor.theme2Color,
        borderRadius: BorderRadius.circular(hight),
      ),
      height: hight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              // 需強制固定大小
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: UiColor.textinputColor,
            ),
          ),
          IconButton(
            constraints: BoxConstraints(minHeight: hight, minWidth: hight),
            style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: onDeleted,
            icon: const Icon(
              Icons.cancel,
              color: UiColor.textinputColor,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
