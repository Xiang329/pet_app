import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/common/app_colors.dart';

class FilterField extends StatefulWidget {
  final Widget filterPage;
  final EdgeInsetsGeometry? margin;
  final bool useHorizontalScroll;
  final Function(Map<String, String>)? onFilterApplied;
  const FilterField({
    super.key,
    required this.filterPage,
    this.margin = const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    this.useHorizontalScroll = false,
    this.onFilterApplied,
  });

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  // List<String> selectedFilters = [];
  List selectedFilters = [];
  Map<String, String> selectedMap = {};

  void _openFilterDialog() async {
    final selectedFilter = showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      builder: (BuildContext context) {
        return Navigator(
          onGenerateRoute: (settings) {
            return CupertinoPageRoute(
                builder: (context) => widget.filterPage, settings: settings);
          },
        );
      },
    );
    // 新增 Filter
    selectedFilter.then((value) {
      selectedFilters = [];
      if (value != null) {
        setState(() {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFilterDialog,
      child: Container(
        height: widget.useHorizontalScroll ? 40 : null,
        margin: widget.margin,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: UiColor.textinput_color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              const Icon(Icons.filter_list),
              const VerticalDivider(),
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

                // 默認元件 Chip 限制多 不同平台尺寸不一
                // children: List.generate(
                //   selectedFilters.length,
                //   (index) => Chip(
                //     side: BorderSide.none,
                //     backgroundColor: UiColor.theme2_color,
                //     // padding: EdgeInsets.zero,
                //     // labelPadding: const EdgeInsets.fromLTRB(10, -3, 0, -3),
                //     shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(20))),
                //     label: Text(selectedFilters[index]),
                //     labelStyle: const TextStyle(
                //       fontWeight: FontWeight.w600,
                //       color: UiColor.textinput_color,
                //     ),
                //     deleteIconColor: UiColor.textinput_color,
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
        color: UiColor.theme2_color,
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
              color: UiColor.textinput_color,
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
              color: UiColor.textinput_color,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
