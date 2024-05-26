import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool _isHidden = true;
  DateTime _datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<AuthModel>(context).loading;

    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        title: const Text('註冊帳號'),
        backgroundColor: UiColor.theme1_color,
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                // Logo圖片
                SvgPicture.asset(
                  AssetsImages.loginLogoSvg,
                ),

                const SizedBox(height: 50),

                // --註冊表單--
                // 姓名輸入框
                OutlinedTextField(
                  controller: nameController,
                  labelText: '姓名',
                  hintText: '姓名',
                ),
                const SizedBox(height: 30),

                // 暱稱輸入框
                OutlinedTextField(
                  controller: nickNameController,
                  labelText: '暱稱',
                  hintText: '暱稱',
                ),
                const SizedBox(height: 30),

                // 生日輸入框
                OutlinedTextField(
                  controller: dateController,
                  readOnly: true,
                  labelText: '生日',
                  hintText: '生日',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          color: UiColor.theme1_color,
                          child: CupertinoDatePicker(
                            initialDateTime: _datetime,
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (datetime) {
                              setState(() {
                                _datetime = datetime;
                                dateController.text = DateFormat('yyyy/MM/dd')
                                    .format(datetime)
                                    .toString();
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),

                // 電子郵件輸入框
                OutlinedTextField(
                  controller: emailController,
                  labelText: '電子郵件',
                  hintText: '電子郵件',
                ),
                const SizedBox(height: 30),

                // 密碼輸入框
                OutlinedTextField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  labelText: '密碼',
                  hintText: '密碼',
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        icon: SvgPicture.asset(_isHidden
                            ? AssetsImages.passwordHideSvg
                            : AssetsImages.passwordShowSvg),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 行動電話輸入框
                OutlinedTextField(
                  controller: phoneNumberController,
                  labelText: '行動電話',
                  hintText: '行動電話',
                ),
                const SizedBox(height: 50),

                // 註冊按鈕
                SizedBox(
                  height: 42,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: UiColor.theme2_color),
                      child: isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '註冊',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () {
                        final userData = {
                          'Member_Email': emailController.text,
                          'Member_Name': nameController.text,
                          'Member_BirthDay': dateController.text,
                          'Member_Mobile': phoneNumberController.text,
                          'Member_Nickname': nickNameController.text,
                        };

                        // bool success =  ApiMethod().postMethod('Members', data);
                        if (!isLoading) {
                          Provider.of<AuthModel>(context, listen: false)
                              .register(
                            context,
                            emailController.text,
                            passwordController.text,
                            userData,
                          );
                        }
                      }),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
