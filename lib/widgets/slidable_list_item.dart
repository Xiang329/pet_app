import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/models/item.dart';
import 'package:pet_app/providers/item_provider.dart';
import 'package:provider/provider.dart';

class SlidableItem extends StatefulWidget {
  final List<Item> itemList;
  final Item item;
  final Function()? onTap;
  const SlidableItem(
      {super.key, required this.item, required this.itemList, this.onTap});

  @override
  State<SlidableItem> createState() => _SlidableItemState();
}

class _SlidableItemState extends State<SlidableItem> {
  // 必須確保更新狀態，否則出錯 A dismissed Slidable widget is still part of the tree.
  // 只需在回調中移除相應的 Pet 對象
  void removeData() {
    Provider.of<ItemProvider>(context, listen: false)
        .removeItem(widget.itemList, widget.item);
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Center(child: Text('刪除成功')),
      duration: Duration(seconds: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          height: 90,
          child: Card(
            color: UiColor.textinput_color,
            clipBehavior: Clip.antiAlias,
            child: Slidable(
              // 如果 Slidable 可以關閉，需指定一個不重複的 Key
              key: UniqueKey(),
          
              // 右測滑塊設置
              endActionPane: ActionPane(
                // 寬度比例
                extentRatio: 0.25,
                dismissible: DismissiblePane(onDismissed: () {
                  removeData();
                }),
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => removeData(),
                    backgroundColor: const Color(0xffe35050),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                title: Text(
                  widget.item.title,
                  style: const TextStyle(
                    color: UiColor.text1_color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  widget.item.subTitle,
                  style: const TextStyle(
                    color: UiColor.text2_color,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
