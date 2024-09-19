import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/social_media.dart';
import 'package:pet_app/pages/socail/comment_page.dart';
import 'package:pet_app/pages/socail/edit_my_post_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  final SocialMedia socialMedia;
  final bool editable;
  const PostItem(
      {super.key, required this.socialMedia, required this.editable});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isExpanded = false;

  bool isOverMaxLines(String text) {
    // 設備寬度 - (Padding 寬度(30) + 誤差(17.5))
    return (TextPainter(
      text: TextSpan(text: text),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (MediaQuery.of(context).size.width) - 47.5))
        .didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          widget.socialMedia.member!.memberMugShot.isEmpty
                              ? const AssetImage(AssetsImages.userAvatorPng)
                              : MemoryImage(
                                  widget.socialMedia.member!.memberMugShot),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.socialMedia.member!.memberName,
                      style: const TextStyle(color: UiColor.text1Color),
                    ),
                  ],
                ),
                if (widget.editable)
                  PopupMenuButton<int>(
                    constraints: const BoxConstraints.tightFor(width: 75),
                    icon: SvgPicture.asset(AssetsImages.optionSvg),
                    offset: const Offset(0, 40),
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
                              color: UiColor.text1Color,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (BuildContext context) => EditMyPostPage(
                              socialMedia: widget.socialMedia,
                            ),
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
                              color: UiColor.text1Color,
                            ),
                          ),
                        ),
                        onTap: () async {
                          try {
                            await Provider.of<AppProvider>(context,
                                    listen: false)
                                .deleteSocialMedia(widget.socialMedia.smId);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Visibility(
            visible: widget.socialMedia.smImage.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 375),
                  child: Image.memory(widget.socialMedia.smImage,
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      widget.socialMedia.smContent,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(color: UiColor.text1Color),
                    ),
                    Visibility(
                      visible: isOverMaxLines(widget.socialMedia.smContent),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              isExpanded ? '隱藏' : '更多',
                              style: const TextStyle(
                                color: UiColor.text2Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        return CommentPage(
                          socialMediaId: widget.socialMedia.smId,
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    iconColor: UiColor.text2Color,
                  ),
                  icon: SvgPicture.asset(AssetsImages.commentSvg),
                  label: const Text(
                    '留言 ',
                    style: TextStyle(color: UiColor.text2Color),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.socialMedia.smDateTime.formatDate(),
                  style: const TextStyle(
                    color: UiColor.navigationBarColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
