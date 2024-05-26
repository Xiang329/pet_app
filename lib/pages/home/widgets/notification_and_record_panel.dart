import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';

class NotificationAndRecordPanel extends StatelessWidget {
  const NotificationAndRecordPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    FixedSizeButton(
                      "通知",
                      icon: SvgPicture.asset(AssetsImages.notificationSvg),
                      backgroundColor: UiColor.textinput_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/notification_page');
                      },
                    ),
                    FixedSizeButton(
                      "疫苗",
                      icon: SvgPicture.asset(AssetsImages.vaccineSvg),
                      backgroundColor: UiColor.theme2_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/vaccine_page');
                      },
                    ),
                    FixedSizeButton(
                      "藥物",
                      icon: SvgPicture.asset(AssetsImages.drugSvg),
                      backgroundColor: UiColor.textinput_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/drug_page');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    FixedSizeButton(
                      "就醫",
                      icon: SvgPicture.asset(AssetsImages.medicaldSvg),
                      backgroundColor: UiColor.theme2_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/medicald_page');
                      },
                    ),
                    FixedSizeButton(
                      "飲食",
                      icon: SvgPicture.asset(AssetsImages.dietSvg),
                      backgroundColor: UiColor.textinput_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/diet_page');
                      },
                    ),
                    FixedSizeButton(
                      "排泄",
                      icon: SvgPicture.asset(AssetsImages.excretionSvg),
                      backgroundColor: UiColor.theme2_color,
                      onPressed: () {
                        Navigator.pushNamed(context, '/excretion_page');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FixedSizeButton extends StatelessWidget {
  final String buttonText;
  final Widget icon;
  final Function()? onPressed;
  final Color? backgroundColor;

  const FixedSizeButton(
    this.buttonText, {
    super.key,
    this.onPressed,
    this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              buttonText,
              style: const TextStyle(
                color: UiColor.text2_color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
