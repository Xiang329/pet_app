import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/social_media_message_board.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatefulWidget {
  final int socialMediaId;
  final SocialMediaMessageBoard socialMediaMessage;
  final Member member;
  final bool editable;
  const CommentItem({
    super.key,
    required this.socialMediaId,
    required this.socialMediaMessage,
    required this.member,
    required this.editable,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController contentController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool editMode = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          editMode = false;
          focusNode.unfocus();
        });
      }
    });
  }

  bool isOverMaxLines(String text) {
    // 設備寬度 - (Padding 寬度(60) + 誤差(12.5))
    return (TextPainter(
      text: TextSpan(text: text),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (MediaQuery.of(context).size.width - 72.5)))
        .didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Slidable(
        key: UniqueKey(),
        endActionPane: (!widget.editable)
            ? null
            : ActionPane(
                motion: const ScrollMotion(),
                // 控制Slidable右側滑塊佔用比例
                // 145 為右側Widget所需佔用寬度
                extentRatio: 145 / constraints.biggest.width,
                children: [
                  // const SizedBox(width: 15),
                  Builder(builder: (context) {
                    return SizedBox(
                      height: 50,
                      width: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: UiColor.theme2Color,
                          shape: const CircleBorder(),
                        ),
                        child: SvgPicture.asset(AssetsImages.editSvg),
                        onPressed: () async {
                          // 根據Builder的context
                          Slidable.of(context)!.close();
                          setState(() {
                            editMode = true;
                            contentController.text =
                                widget.socialMediaMessage.mbContent;
                            FocusScope.of(context).requestFocus(focusNode);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 15),
                  Builder(
                    builder: (context) {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: UiColor.errorColor,
                            shape: const CircleBorder(),
                          ),
                          child: SvgPicture.asset(AssetsImages.deleteSvg),
                          onPressed: () async {
                            // 根據Builder的context
                            Slidable.of(context)!.close();
                            try {
                              await Provider.of<AppProvider>(context, listen: false)
                                  .deleteMessageBoard(widget.socialMediaId,
                                      widget.socialMediaMessage.mbId);
                            } catch (e) {
                              debugPrint('$e');
                            }
                          },
                        ),
                      );
                    }
                  ),
                  const SizedBox(width: 15),
                ],
              ),
        child: Card(
          color: UiColor.textinputColor,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: widget.member.memberMugShot.isEmpty
                              ? const AssetImage(AssetsImages.userAvatorPng)
                              : MemoryImage(widget.member.memberMugShot),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.member.memberName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: UiColor.text1Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                (editMode == true)
                    ? Form(
                        key: _formKey,
                        child: FilledTextField(
                          controller: contentController,
                          focusNode: focusNode,
                          validator: (value) => Validators.stringValidator(
                            value,
                            errorMessage: '留言',
                          ),
                          suffixIcon: IconButton(
                            alignment: Alignment.center,
                            icon: SvgPicture.asset(AssetsImages.sendSvg),
                            onPressed: () async {
                              final messageBoardData = {
                                'MB_ID': widget.socialMediaMessage.mbId,
                                'MB_SID': widget.socialMediaId,
                                'MB_MemberID':
                                    widget.socialMediaMessage.mbMemberId,
                                'MB_Content': contentController.text,
                                'MB_DateTime': widget
                                    .socialMediaMessage.mbDateTime
                                    .toIso8601String(),
                              };
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await Provider.of<AppProvider>(context,
                                          listen: false)
                                      .editMessageBoard(
                                          widget.socialMediaId,
                                          widget.socialMediaMessage.mbId,
                                          messageBoardData);
                                } catch (e) {
                                  debugPrint('$e');
                                } finally {
                                  setState(() {
                                    editMode = false;
                                    focusNode.unfocus();
                                  });
                                }
                              }
                            },
                          ),
                          topLeftRadius: 8,
                          topRightRadius: 8,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            widget.socialMediaMessage.mbContent,
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: UiColor.text1Color,
                            ),
                          ),
                          Visibility(
                            visible: isOverMaxLines(
                                widget.socialMediaMessage.mbContent),
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
                Text(
                  widget.socialMediaMessage.mbDateTime.formatDateWithTime(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: UiColor.navigationBarColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
