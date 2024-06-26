import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:pet_app/models/member.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Member member;
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  DateTime _datetime = DateTime.now();

  @override
  void initState() {
    // _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      final userEmail =
          Provider.of<AuthModel>(context, listen: false).user?.email;
      member = await ApiMethod().getMethod_Member(userEmail);
      nameController.text = member.memberName;
      nickNameController.text = member.memberNickname;
      dateController.text =
          DateFormat('yyyy/MM/dd').format(member.memberBirthDay);
      _datetime = member.memberBirthDay;
      emailController.text = member.memberEmail;
      phoneNumberController.text = member.memberMobile;
    } catch (e) {
      print(e);
    }
  }

  Widget _buildView() {
    final userEmail =
        Provider.of<AuthModel>(context, listen: false).user?.email;
    final member = Provider.of<MemberProvider>(context).member!;
    nameController.text = member.memberName;
    nickNameController.text = member.memberNickname;
    dateController.text =
        DateFormat('yyyy/MM/dd').format(member.memberBirthDay);
    _datetime = member.memberBirthDay;
    emailController.text = member.memberEmail;
    phoneNumberController.text = member.memberMobile;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 47, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 56,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: AssetImage(AssetsImages.catJpg),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        color: UiColor.theme2_color,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 80),
          Card(
            color: UiColor.theme1_color,
            shadowColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledTextField(
                  controller: nameController,
                  labelText: '姓名',
                  hintText: "用戶本名",
                ),
                const SizedBox(height: 25),
                FilledTextField(
                  controller: nickNameController,
                  labelText: '暱稱',
                  hintText: "用戶暱稱",
                ),
                const SizedBox(height: 25),
                FilledTextField(
                  labelText: '生日',
                  readOnly: true,
                  controller: dateController,
                  onTap: () {
                    showModalBottomSheet(
                      clipBehavior: Clip.antiAlias,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          color: UiColor.theme1_color,
                          child: CupertinoDatePicker(
                            initialDateTime: _datetime,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (datetime) {
                              _datetime = datetime;
                              dateController.text =
                                  DateFormat('yyyy/MM/dd').format(datetime);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
                FilledTextField(
                  readOnly: true,
                  controller: emailController,
                  labelText: '電子郵件',
                  hintText: "hamster@gmail.com",
                ),
                const SizedBox(height: 25),
                FilledTextField(
                  controller: phoneNumberController,
                  labelText: '行動電話',
                  hintText: "0912345678",
                ),
                const SizedBox(height: 25),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 10),
                  onTap: () {
                    Navigator.pushNamed(context, '/change_password_page');
                  },
                  tileColor: const Color(0xFFF7EFD8),
                  title: const Text(
                    '變更密碼',
                    style: TextStyle(
                        color: Color(0xFF593922),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: UiColor.text2_color),
                ),
                const SizedBox(height: 25),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 10),
                  onTap: () {
                    Navigator.pushNamed(context, '/del_account_page');
                  },
                  tileColor: const Color(0xFFF7EFD8),
                  title: const Text(
                    '刪除帳號',
                    style: TextStyle(
                        color: Color(0xFF593922),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: UiColor.text2_color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 42,
            child: TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: UiColor.theme2_color),
              child: const Text(
                '完成',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final userData = {
                  "Member_ID": member.memberId,
                  'Member_Email': member.memberEmail,
                  'Member_Name': nameController.text,
                  'Member_BirthDay': dateController.text,
                  'Member_Mobile': phoneNumberController.text,
                  'Member_Nickname': nickNameController.text,
                };
                await ApiMethod().putMethod_Member(userEmail, userData);
                Provider.of<MemberProvider>(context, listen: false)
                    .updateMember();
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("個人檔案"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: _buildView(),
    );
  }
}
