import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/add_picture.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController contentController = TextEditingController();
  Uint8List? picture;

  Future submit() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    DateTime dateTime = DateTime.now();
    BuildContext? dialogContext;
    final socialMediaData = {
      'SM_MemberID': appProvider.memberId,
      'SM_Image': picture,
      'SM_Content': contentController.text,
      'SM_DateTime': dateTime.toIso8601String(),
    };
    try {
      if (_formKey.currentState!.validate()) {
        await Provider.of<AppProvider>(context, listen: false)
            .addSocialMedia(socialMediaData)
            .then((_) {
          if (!context.mounted) return;
          if (dialogContext != null) {
            Navigator.of(dialogContext!, rootNavigator: true).pop();
          }
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return CupertinoAlertDialog(
            title: const Text('錯誤'),
            content: Text(e.toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(dialogContext!).pop();
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
        title: const Text("新增貼文"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                    maxWidth: 320,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: UiColor.navigationBarColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    image: picture == null
                        ? null
                        : DecorationImage(image: MemoryImage(picture!)),
                  ),
                  child: Stack(
                    children: [
                      AddPicture(
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
                ),
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: contentController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '內容',
                ),
                labelText: '加上解說...',
                maxLines: 4,
                alignLabelWithHint: true,
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: CustomButton(asyncOnPressed: submit, buttonText: '發布'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
