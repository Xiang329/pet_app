import 'package:flutter/foundation.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/members_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:pet_app/model/member.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Member? _member;
  Uint8List? picture;
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  DateTime _datetime = DateTime.now();

  Future submit() async {
    final memberData = {
      "Member_ID": _member!.memberId,
      'Member_Email': _member!.memberEmail,
      'Member_Name': nameController.text,
      'Member_BirthDay': _datetime.toIso8601String(),
      'Member_Mobile': phoneNumberController.text,
      'Member_Nickname': nickNameController.text,
      'Member_MugShot': picture,
    };
    debugPrint(memberData.toString());
    if (_formKey.currentState!.validate()) {
      try {
        await MembersService.updateMember(_member!.memberEmail, memberData)
            .then((_) async {
          if (!mounted) return;
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('通知'),
                content: const Text('個人資料修改成功。'),
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
          if (!mounted) return;
          await Provider.of<AppProvider>(context, listen: false).updateMember();
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("個人檔案"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: Selector<AppProvider, Member?>(
          selector: (context, appProvider) => appProvider.member,
          builder: (context, member, child) {
            if (member != null && _member == null) {
              _member = member;
              nameController.text = member.memberName;
              nickNameController.text = member.memberNickname;
              dateController.text = member.memberBirthDay.formatDate();
              _datetime = member.memberBirthDay!;
              emailController.text = member.memberEmail;
              phoneNumberController.text = member.memberMobile!;
              picture = member.memberMugShot;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundImage: (picture == null)
                                ? const AssetImage(AssetsImages.userAvatorPng)
                                : picture!.isEmpty
                                    ? const AssetImage(
                                        AssetsImages.userAvatorPng)
                                    : MemoryImage(picture!),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                color: UiColor.theme2Color,
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await ImageUtils.pickImage().then((img) {
                                    if (img != null) {
                                      picture = img;
                                      setState(() {});
                                    }
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Card(
                      color: UiColor.theme1Color,
                      shadowColor: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledLeftLabelTextField(
                            controller: nameController,
                            validator: (value) => Validators.stringValidator(
                              value,
                              errorMessage: '姓名',
                            ),
                            labelText: '姓名',
                          ),
                          const SizedBox(height: 10),
                          FilledLeftLabelTextField(
                            controller: nickNameController,
                            validator: (value) => Validators.stringValidator(
                              value,
                              errorMessage: '姓名',
                            ),
                            labelText: '暱稱',
                          ),
                          const SizedBox(height: 10),
                          FilledLeftLabelTextField(
                            labelText: '生日',
                            validator: (value) =>
                                Validators.dateTimeValidator(value),
                            readOnly: true,
                            controller: dateController,
                            onTap: () {
                              showModalBottomSheet(
                                clipBehavior: Clip.antiAlias,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 300,
                                    color: UiColor.theme1Color,
                                    child: CupertinoDatePicker(
                                      initialDateTime: _datetime,
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (datetime) {
                                        _datetime = datetime;
                                        dateController.text =
                                            datetime.formatDate();
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          FilledLeftLabelTextField(
                            readOnly: true,
                            controller: emailController,
                            labelText: '電子郵件',
                          ),
                          const SizedBox(height: 10),
                          FilledLeftLabelTextField(
                            controller: phoneNumberController,
                            validator: (value) =>
                                Validators.phoneValidator(value),
                            labelText: '行動電話',
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 16, right: 10),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/change_password_page');
                            },
                            tileColor: UiColor.textinputColor,
                            title: const Text(
                              '變更密碼',
                              style: TextStyle(
                                  color: UiColor.text1Color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                SvgPicture.asset(AssetsImages.arrowEnterSvg),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 16, right: 10),
                            onTap: () {
                              Navigator.pushNamed(context, '/del_account_page');
                            },
                            tileColor: UiColor.textinputColor,
                            title: const Text(
                              '刪除帳號',
                              style: TextStyle(
                                  color: UiColor.text1Color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing:
                                SvgPicture.asset(AssetsImages.arrowEnterSvg),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 42,
                    child:
                        CustomButton(asyncOnPressed: submit, buttonText: '完成'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }),
    );
  }
}
