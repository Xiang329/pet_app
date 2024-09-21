import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool _isHidden = true;
  DateTime _datetime = DateTime.now();

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'Member_Email': emailController.text,
        'Member_Name': nameController.text,
        'Member_BirthDay': _datetime.toIso8601String(),
        'Member_Mobile': phoneNumberController.text,
        'Member_Nickname': nickNameController.text,
      };
      try {
        await Provider.of<AuthModel>(context, listen: false).register(
          context,
          emailController.text,
          passwordController.text,
          userData,
        );
      } catch (e) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('註冊失敗'),
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
        title: const Text('註冊帳號'),
        backgroundColor: UiColor.theme1Color,
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    // Logo圖片
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset(
                        AssetsImages.logoPng,
                        height: 172,
                        width: 156,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --註冊表單--
                    // 姓名輸入框
                    OutlinedTextField(
                      controller: nameController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '姓名',
                      ),
                      labelText: '姓名',
                      hintText: '姓名',
                    ),
                    const SizedBox(height: 30),

                    // 暱稱輸入框
                    OutlinedTextField(
                      controller: nickNameController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '暱稱',
                      ),
                      labelText: '暱稱',
                      hintText: '暱稱',
                    ),
                    const SizedBox(height: 30),

                    // 生日輸入框
                    OutlinedTextField(
                      controller: dateController,
                      readOnly: true,
                      validator: (value) => Validators.dateTimeValidator(value),
                      labelText: '生日',
                      hintText: '生日',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              dateController.text = _datetime.formatDate();
                            });
                            return Container(
                              height: 300,
                              color: UiColor.theme1Color,
                              child: CupertinoDatePicker(
                                initialDateTime: _datetime,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (datetime) {
                                  setState(() {
                                    _datetime = datetime;
                                    dateController.text = datetime.formatDate();
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
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => Validators.emailVaildator(value),
                      labelText: '電子郵件',
                      hintText: '電子郵件',
                    ),
                    const SizedBox(height: 30),

                    // 密碼輸入框
                    OutlinedTextField(
                      controller: passwordController,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) => Validators.passwordVaildator(value),
                      labelText: '密碼',
                      hintText: '密碼',
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                      validator: (value) => Validators.phoneValidator(value),
                      labelText: '行動電話',
                      hintText: '行動電話',
                    ),
                    const SizedBox(height: 50),

                    // 註冊按鈕
                    SizedBox(
                      height: 42,
                      child: CustomButton(
                          asyncOnPressed: submit, buttonText: '註冊'),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
