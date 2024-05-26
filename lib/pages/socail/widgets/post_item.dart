import 'package:flutter/material.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/socail/comment_page.dart';
import 'package:pet_app/pages/socail/edit_my_post_page.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 10),
                  Text(
                    '使用者暱稱',
                    style: TextStyle(color: UiColor.text1_color),
                  ),
                ],
              ),
              PopupMenuButton<int>(
                constraints: const BoxConstraints.tightFor(width: 75),
                icon: const Icon(Icons.more_horiz),
                offset: const Offset(0, kToolbarHeight),
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    height: 40,
                    value: 1,
                    child: const Center(
                      child: Text(
                        '編輯',
                        style: TextStyle(
                          color: UiColor.text1_color,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const EditMyPostPage(),
                      ));
                    },
                  ),
                  const PopupMenuDivider(height: 0),
                  PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    height: 40,
                    value: 2,
                    child: const Center(
                      child: Text(
                        '刪除',
                        style: TextStyle(
                          color: UiColor.text1_color,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 375, maxHeight: 375),
            child: Image.asset(AssetsImages.dogJpg, fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容內容',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: UiColor.text1_color),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    isScrollControlled: true,
                    context: context,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    builder: (BuildContext context) {
                      return const CommentPage();
                    },
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  iconColor: UiColor.text2_color,
                ),
                icon: const Icon(Icons.message),
                label: const Text(
                  '留言',
                  style: TextStyle(color: UiColor.text2_color),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '2024年4月10日',
                style: TextStyle(color: UiColor.navigationBar_color),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
