import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_app/model/advice.dart';
import 'package:pet_app/model/diet.dart';
import 'package:pet_app/model/drug.dart';
import 'package:pet_app/model/excretion.dart';
import 'package:pet_app/model/medical.dart';
import 'package:pet_app/model/vaccine.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/advices_serivce.dart';
import 'package:pet_app/services/diets_serivce.dart';
import 'package:pet_app/services/durgs_serivce.dart';
import 'package:pet_app/services/excretions_serivce.dart';
import 'package:pet_app/services/medicals_service.dart';
import 'package:pet_app/services/pet_managements_service.dart';
import 'package:pet_app/services/vaccines_serivce.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/widgets/common_dialog.dart';
import 'package:provider/provider.dart';

class SlidableItem extends StatefulWidget {
  final Advice? advice;
  final Diet? diet;
  final Drug? drug;
  final Excretion? excretion;
  final Medical? medical;
  final Vaccine? vaccine;
  final Function()? onTap;
  final bool editable;
  final int pmId;
  const SlidableItem({
    super.key,
    this.onTap,
    this.advice,
    this.diet,
    this.drug,
    this.excretion,
    this.medical,
    this.vaccine,
    required this.editable,
    required this.pmId,
  });

  @override
  State<SlidableItem> createState() => _SlidableItemState();
}

class _SlidableItemState extends State<SlidableItem> {
  Future<bool> checkPermission() async {
    bool editable = false;
    await PetManagementsService.getPetManagement(widget.pmId).then((pm) {
      editable = pm.pmPermissions != '3';
    });
    return editable;
  }

  void removeData() async {
    CommonDialog.showConfirmDialog(
      context: context,
      titleText: '是否確定刪除？',
      onConfirmPressed: () async {
        try {
          if (await checkPermission() == false) {
            throw '沒有足夠的權限。';
          }
          if (widget.advice != null) {
            await AdvicesService.deleteAdvice(widget.advice!.adviceId);
          } else if (widget.diet != null) {
            await DietsService.deleteDiet(widget.diet!.dietId);
          } else if (widget.drug != null) {
            await DrugsService.deleteDrug(widget.drug!.drugId);
          } else if (widget.excretion != null) {
            await ExcretionsService.deleteExcretion(
                widget.excretion!.excretionId);
          } else if (widget.medical != null) {
            await MedicalsService.deleteMedical(widget.medical!.medicalId);
          } else if (widget.vaccine != null) {
            await VaccinesService.deleteVaccine(widget.vaccine!.vaccineId);
          }
          if (!mounted) return;
          await Provider.of<AppProvider>(context, listen: false).updateMember();
        } catch (e) {
          if (!mounted) return;
          rethrow;
        }
      },
    );
  }

  String getTitle() {
    Map<String?, String?> fields = {
      'advice': widget.advice?.adviceTitle,
      'vaccine': widget.vaccine?.vaccineName,
      'drug': widget.drug?.drugName,
      'medical': widget.medical?.medicalClinic,
      'diet': widget.diet?.dietDateTime.formatDate(),
      'excretion': widget.excretion?.excretionDateTime.formatDate(),
    };

    for (var field in fields.values) {
      if (field != null && field.isNotEmpty) {
        return field;
      }
    }
    return 'Title';
  }

  String getSubTitle() {
    Map<String?, String?> subTitleMap = {
      'advice': widget.advice?.adviceContent,
      'vaccine': widget.vaccine?.vaccineDate.formatDate(),
      'drug': widget.drug?.drugDate.formatDate(),
      'medical': widget.medical?.medicalDate.formatDate(),
      'diet': widget.diet?.dietDateTime.formatTime(),
      'excretion': widget.excretion?.excretionDateTime.formatTime(),
    };

    for (var subTitle in subTitleMap.values) {
      if (subTitle != null && subTitle.isNotEmpty) {
        return subTitle;
      }
    }
    return 'SubTitle';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: SizedBox(
        height: 70,
        child: Card(
          color: UiColor.textinputColor,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: (widget.editable)
                ? Slidable(
                    // 如果 Slidable 可以關閉，需指定一個不重複的 Key
                    key: UniqueKey(),

                    // 右測滑塊設置
                    endActionPane: ActionPane(
                      // 寬度比例
                      extentRatio: 0.25,
                      motion: const DrawerMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) => removeData(),
                          backgroundColor: UiColor.errorColor,
                          foregroundColor: Colors.white,
                          child: SvgPicture.asset(AssetsImages.deleteSvg),
                        ),
                      ],
                    ),
                    child: slidableListTile(),
                  )
                : slidableListTile(),
          ),
        ),
      ),
    );
  }

  Widget slidableListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTitle(),
                style: const TextStyle(
                  color: UiColor.text1Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                getSubTitle(),
                style: const TextStyle(
                  color: UiColor.text2Color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
