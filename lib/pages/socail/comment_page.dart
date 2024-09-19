import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/social_media_message_board.dart';
import 'package:pet_app/pages/socail/widgets/comment_item.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final int socialMediaId;
  const CommentPage({super.key, required this.socialMediaId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Future loadData;
  List<(SocialMediaMessageBoard, Member)> socialMediaMessageBoard = [];

  @override
  void initState() {
    super.initState();
    loadData = loadMessagesData();
  }

  Future loadMessagesData() async {
    await Provider.of<AppProvider>(context, listen: false)
        .fetchCurrentMessageBoards(widget.socialMediaId);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController contentController = TextEditingController();
    final memberId = Provider.of<AppProvider>(context).memberId;

    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("留言"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowDownSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: Selector<AppProvider,
                    List<(SocialMediaMessageBoard, Member)>>(
                  selector: (context, appProvider) =>
                      appProvider.messageBorders,
                  builder: (context, messageBorders, child) {
                    socialMediaMessageBoard.clear();
                    socialMediaMessageBoard.addAll(messageBorders);
                    if (socialMediaMessageBoard.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AssetsImages.noCommentsPng),
                            const Text(
                              '尚無留言',
                              style: TextStyle(
                                color: UiColor.text2Color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SlidableAutoCloseBehavior(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: socialMediaMessageBoard.length,
                        itemBuilder: (context, index) {
                          return CommentItem(
                            socialMediaId: widget.socialMediaId,
                            socialMediaMessage:
                                socialMediaMessageBoard[index].$1,
                            member: socialMediaMessageBoard[index].$2,
                            editable: memberId ==
                                socialMediaMessageBoard[index].$2.memberId,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 0),
                      ),
                    );
                  },
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: FilledTextField(
                    controller: contentController,
                    validator: (value) => Validators.stringValidator(
                      value,
                      errorMessage: '留言',
                    ),
                    hintText: '新增留言',
                    suffixIcon: IconButton(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      icon: SvgPicture.asset(AssetsImages.sendSvg),
                      onPressed: () async {
                        final messageBoardData = {
                          'MB_SID': widget.socialMediaId,
                          'MB_MemberID': memberId,
                          'MB_Content': contentController.text,
                          'MB_DateTime': DateTime.now().toIso8601String(),
                        };
                        try {
                          if (_formKey.currentState!.validate()) {
                            await Provider.of<AppProvider>(context,
                                    listen: false)
                                .addMessageBoard(
                                    widget.socialMediaId, messageBoardData);
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('錯誤'),
                                content: Text(e.toString()),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text('確定'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } finally {
                          contentController.text = '';
                        }
                      },
                    ),
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    bottomLeftRadius: 8,
                    bottomRightRadius: 8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
