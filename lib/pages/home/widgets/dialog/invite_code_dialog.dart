import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/services/pets_service.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_text_field.dart';
import 'package:provider/provider.dart';

class InviteCodeDialog extends StatefulWidget {
  const InviteCodeDialog({
    super.key,
  });

  @override
  State<InviteCodeDialog> createState() => _InviteCodeDialogState();
}

class _InviteCodeDialogState extends State<InviteCodeDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController codeController = TextEditingController();

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      final member = Provider.of<AppProvider>(context, listen: false).member;
      try {
        await PetsService.getPetByCode(codeController.text).then((pet) async {
          for (var pm in pet!.petManagementList) {
            if (member?.memberId == pm.member?.memberId) {
              throw ('無法新增自己的寵物');
            }
          }
          final petManagementData = {
            "PM_MemberID": member?.memberId,
            "PM_PetID": pet.petId,
            "PM_Permissions": '2',
          };
          debugPrint(petManagementData.toString());
          await PetManagementsService.createPetManagement(petManagementData);
          if (!mounted) return;
          await Provider.of<AppProvider>(context, listen: false).updateMember();
        });
        if (!mounted) return;
        Navigator.of(context).pop(codeController.text);
      } catch (e) {
        if (!context.mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('新增失敗'),
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: IntrinsicWidth(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              // 耳朵高度
              top: -35,
              bottom: 0,
              right: 0,
              left: 0,
              child: SvgPicture.asset(AssetsImages.dialogSvg),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "請輸入邀請碼",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: UiColor.text1Color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledTextField(
                      controller: codeController,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiColor.theme2Color,
                      ),
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '邀請碼',
                        onlyInt: true,
                      ),
                      textAlign: TextAlign.center,
                      labelSize: 14,
                      height: 10,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 96,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: const BorderSide(
                                  width: 2, color: UiColor.theme2Color),
                            ),
                            child: const Text(
                              '取消',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: UiColor.theme2Color,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 36,
                          width: 96,
                          child: CustomButton(
                              asyncOnPressed: submit, buttonText: '加入'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
