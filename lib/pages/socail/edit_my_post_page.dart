import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/social_media.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/add_picture.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class EditMyPostPage extends StatefulWidget {
  final SocialMedia socialMedia;
  const EditMyPostPage({super.key, required this.socialMedia});

  @override
  State<EditMyPostPage> createState() => _EditMyPostPageState();
}

class _EditMyPostPageState extends State<EditMyPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController contentController = TextEditingController();
  Uint8List? picture;

  @override
  void initState() {
    super.initState();
    contentController.text = widget.socialMedia.smContent;
    picture =
        widget.socialMedia.smImage.isEmpty ? null : widget.socialMedia.smImage;
  }

  Future submit() async {
    final socialMediaData = {
      'SM_ID': widget.socialMedia.smId,
      'SM_MemberID': widget.socialMedia.smMemberId,
      'SM_Image': picture,
      'SM_Content': contentController.text,
      'SM_DateTime': widget.socialMedia.smDateTime.toIso8601String(),
    };
    try {
      if (_formKey.currentState!.validate()) {
        await Provider.of<AppProvider>(context, listen: false)
            .editSocialMedia(widget.socialMedia.smId, socialMediaData)
            .then((_) {
          if (!mounted) return;
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      if (!mounted) return;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("編輯貼文"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        // maxWidth: 375,
                        maxHeight: 375,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: UiColor.textinputColor,
                        borderRadius: BorderRadius.circular(12.0),
                        image: picture == null
                            ? null
                            : DecorationImage(image: MemoryImage(picture!)),
                      ),
                      child: AddPicture(
                        visible: picture == null,
                        onTap: () async {
                          await ImageUtils.pickImage().then((img) {
                            if (img != null) {
                              picture = img;
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: picture != null,
                      child: Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                size: 15, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                picture = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                FilledTextField(
                  controller: contentController,
                  validator: (value) => Validators.stringValidator(
                    value,
                    errorMessage: '內容',
                  ),
                  labelText: '',
                  maxLines: 4,
                  alignLabelWithHint: true,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 42,
                  child: CustomButton(asyncOnPressed: submit, buttonText: '完成'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
