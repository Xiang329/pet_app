import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/area_data.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:pet_app/widgets/left_label_dropdown_list.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class EditMyFoundPage extends StatefulWidget {
  final Finding finding;
  const EditMyFoundPage({super.key, required this.finding});

  @override
  State<EditMyFoundPage> createState() => _EditMyFoundPageState();
}

class _EditMyFoundPageState extends State<EditMyFoundPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController classNameController = TextEditingController();
  TextEditingController varietyNameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController foundDateController = TextEditingController();
  TextEditingController foundPlaceController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  DateTime _datetime = DateTime.now();
  Uint8List? picture;

  final petClassesMap = PetClassesService.petClassesMap;
  final petVarietiesMap = PetVarietiesService.petVarietyMap;
  final petVarietyMapByPcId = PetVarietiesService.petVarietyMapByPcId;

  List<String> petGender = [
    '男',
    '女',
  ];

  int? selectedPetClassId;
  int? selectedPetVarietyId;
  String? selectedPetClass;
  String? selectedPetVariety;
  String? selectedPetSex;
  String? selectedCity;
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    contentController.text = widget.finding.findingContent;
    foundDateController.text = widget.finding.findingDateTime.formatDate();
    _datetime = widget.finding.findingDateTime;
    picture = widget.finding.findingImage;
    mobileController.text = widget.finding.findingMobile.toString();
    selectedPetClassId = petClassesMap.entries
        .firstWhereOrNull(
            (element) => element.value == widget.finding.className)
        ?.key;
    selectedPetVarietyId = petVarietiesMap.entries
        .firstWhereOrNull((element) =>
            element.value.pvVarietyName == widget.finding.varietyName)
        ?.key;
    selectedPetClass = petClassesMap.values
        .firstWhereOrNull((value) => value.contains(widget.finding.className));
    selectedPetVariety = petVarietiesMap.values
        .firstWhereOrNull(
            (value) => value.pvVarietyName.contains(widget.finding.varietyName))
        ?.pvVarietyName;
    selectedPetSex = widget.finding.findingSex == null
        ? null
        : petGender.firstWhereOrNull(
            (value) => value.contains(widget.finding.findingSex! ? '男' : '女'));

    selectedCity = areaData.keys.firstWhereOrNull(
        (value) => widget.finding.findingPlace.contains(value));
    selectedDistrict = areaData[selectedCity]?.firstWhereOrNull(
        (value) => widget.finding.findingPlace.contains(value));
    if (selectedCity != null && selectedDistrict != null) {
      foundPlaceController.text = widget.finding.findingPlace
          .replaceFirst(selectedCity!, '')
          .replaceFirst(selectedDistrict!, '');
    }
  }

  Future submit() async {
    final fullAddress =
        '$selectedCity$selectedDistrict${foundPlaceController.text}';
    final findingData = {
      'Finding_ID': widget.finding.findingId,
      'Finding_MemberID': widget.finding.findingMemberId,
      'Finding_LostOrFound': widget.finding.findingLostOrFound,
      'Finding_Content': contentController.text,
      'Finding_DataTime': _datetime.toIso8601String(),
      'Finding_Place': fullAddress,
      'Finding_Image': picture,
      'Finding_PetID': null,
      "Finding_PC": selectedPetClassId,
      "Finding_PV": selectedPetVarietyId,
      "Finding_Sex": selectedPetSex == '男',
      "Finding_Mobile": mobileController.text,
    };
    debugPrint(findingData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await Provider.of<AppProvider>(context, listen: false)
            .editPetFinding(widget.finding.findingId, findingData);
        if (!mounted) return;
        Navigator.of(context).pop(true);
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2Color,
        title: const Text("編輯拾獲資訊"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 375,
                  maxHeight: 375,
                ),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: widget.finding.findingImage.isEmpty
                          ? Image.asset(AssetsImages.petPhotoPng)
                          : Image.memory(widget.finding.findingImage),
                    ),
                    Positioned(
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
                          onPressed: () async {
                            await ImageUtils.pickImage().then((img) {
                              if (img != null) {
                                picture = img;
                                setState(() {});
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LeftLabelDropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '類別',
                      ),
                      title: '類別',
                      items: petClassesMap.values.toList(),
                      value: selectedPetClass,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      onChanged: (value) {
                        selectedPetClassId = petClassesMap.entries
                            .firstWhereOrNull(
                                (element) => element.value == value)
                            ?.key;
                        setState(() {
                          selectedPetClass = value;
                          selectedPetVariety = null;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    LeftLabelDropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '品種',
                      ),
                      title: '品種',
                      items: petVarietyMapByPcId[selectedPetClassId] ?? [],
                      value: selectedPetVariety,
                      onChanged: (value) {
                        selectedPetVarietyId = petVarietiesMap.entries
                            .firstWhereOrNull((element) =>
                                element.value.pvVarietyName == value)
                            ?.key;
                        setState(() {
                          selectedPetVariety = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    LeftLabelDropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '性別',
                      ),
                      title: '性別',
                      items: petGender,
                      value: selectedPetSex,
                      onChanged: (value) {
                        setState(() {
                          selectedPetSex = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: contentController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '其他描述',
                      ),
                      labelText: '其他描述',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: foundDateController,
                      readOnly: true,
                      labelText: '拾獲日期',
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
                                  foundDateController.text =
                                      datetime.formatDate();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: LeftLabelDropdownList(
                            validator: (value) =>
                                Validators.dropDownListValidator(
                              value,
                              errorMessage: '拾獲縣市',
                            ),
                            title: '拾獲縣市',
                            items: areaData.keys.toList(),
                            value: selectedCity,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDistrict = null;
                                selectedCity = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: LeftLabelDropdownList(
                            validator: (value) =>
                                Validators.dropDownListValidator(
                              value,
                              errorMessage: '拾獲區域',
                            ),
                            title: '拾獲區域',
                            items: areaData[selectedCity] ?? [],
                            value: selectedDistrict,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDistrict = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: foundPlaceController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '拾獲地點',
                      ),
                      labelText: '拾獲地點',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: mobileController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '聯絡方式',
                        onlyInt: true,
                      ),
                      labelText: '聯絡方式',
                      maxLines: 4,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 42,
                child: CustomButton(asyncOnPressed: submit, buttonText: '確定'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
