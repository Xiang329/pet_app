import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/diet/diet_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/drug/drug_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/excretion/excretion_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/medical/medical_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/notification/notification_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/vaccine/vaccine_page.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:provider/provider.dart';

class NotificationAndRecordPanel extends StatelessWidget {
  final int pmId;
  const NotificationAndRecordPanel({
    super.key,
    required this.pmId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final bool isOverMaxWidth = 1000 > constraints.maxWidth;
              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20,
                // 垂直間距
                runSpacing: 20,
                children: [
                  FixedSizeButton(
                    "通知",
                    icon: SvgPicture.asset(AssetsImages.notificationSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NotificationPage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  FixedSizeButton(
                    "藥物",
                    icon: SvgPicture.asset(AssetsImages.drugSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DrugPage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  FixedSizeButton(
                    "就醫",
                    icon: SvgPicture.asset(AssetsImages.medicalSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MedicalPage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  FixedSizeButton(
                    "疫苗",
                    icon: SvgPicture.asset(AssetsImages.vaccineSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => VaccinePage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  FixedSizeButton(
                    "排泄",
                    icon: SvgPicture.asset(AssetsImages.excretionSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ExcretionPage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  FixedSizeButton(
                    "飲食",
                    icon: SvgPicture.asset(AssetsImages.dietSvg),
                    backgroundColor: UiColor.textinputColor,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DietPage(pmId: pmId),
                        ),
                      );
                    },
                  ),
                  if (isOverMaxWidth) ...[
                    const SizedBox(width: 140),
                    const SizedBox(width: 140),
                  ],
                ],
              );
            }),
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
      width: 140,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                Provider.of<AppProvider>(context, listen: false).updateMember();
                onPressed!.call();
              },
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60, width: 60, child: icon),
            Text(
              buttonText,
              style: const TextStyle(
                color: UiColor.text2Color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
