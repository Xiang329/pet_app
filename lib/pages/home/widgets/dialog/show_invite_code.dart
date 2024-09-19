import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_text_field.dart';

class ShowInviteCodeDialog extends StatefulWidget {
  final Pet pet;
  const ShowInviteCodeDialog({
    super.key,
    required this.pet,
  });

  @override
  State<ShowInviteCodeDialog> createState() => _ShowInviteCodeDialogState();
}

class _ShowInviteCodeDialogState extends State<ShowInviteCodeDialog> {
  TextEditingController codeController = TextEditingController();
  int selectedOption = 1;

  @override
  void initState() {
    super.initState();
    codeController.text = widget.pet.petInvCode;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.pet.petName} 的邀請碼是',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: UiColor.text1Color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledTextField(
                    readOnly: true,
                    controller: codeController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: UiColor.theme2Color,
                    ),
                    textAlign: TextAlign.center,
                    suffixIcon: IconButton(
                      icon: SvgPicture.asset(AssetsImages.copySvg),
                      onPressed: () {},
                    ),
                    labelSize: 14,
                    height: 10,
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    bottomLeftRadius: 8,
                    bottomRightRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 36,
                    width: 96,
                    child: CustomButton(
                        syncOnPressed: Navigator.of(context).pop,
                        buttonText: '確定'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
