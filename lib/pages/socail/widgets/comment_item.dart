import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/common/app_colors.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({super.key});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.35,
        children: [
          const SizedBox(width: 15),
          Builder(
            builder: (context) {
              return CircleAvatar(
                backgroundColor: UiColor.theme2_color,
                radius: 25,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {
                    Slidable.of(context)!.close();
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 15),
          Builder(
            builder: (context) {
              return CircleAvatar(
                backgroundColor: const Color(0xFFE35050),
                radius: 25,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    Slidable.of(context)!.close();

                  },
                ),
              );
            },
          ),
        ],
      ),
      // 右測滑塊設置
      // endActionPane: ActionPane(
      //   // 寬度比例
      //   extentRatio: 0.3,
      //   dismissible: DismissiblePane(onDismissed: () {}),
      //   // motion: const DrawerMotion(),
      //   motion: const ScrollMotion(),
      //   children: [
      //     SlidableAction(
      //       onPressed: (context) => (),
      //       backgroundColor: const Color(0xffe35050),
      //       foregroundColor: Colors.white,
      //       icon: Icons.delete,
      //       label: '刪除',
      //     ),
      //   ],
      // ),
      child: const Card(
        color: UiColor.textinput_color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Text("data"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text("2024年4月10日"),
            ],
          ),
        ),
      ),
    );
  }
}
