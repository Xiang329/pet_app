import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/area_data.dart';
import 'package:pet_app/model/finding.dart';
import 'package:pet_app/model/pet.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/filled_left_label_text_field.dart';
import 'package:pet_app/widgets/left_label_dropdown_list.dart';
import 'package:provider/provider.dart';

class EditMyMissingPage extends StatefulWidget {
  final Finding finding;
  final Pet pet;
  const EditMyMissingPage({
    super.key,
    required this.finding,
    required this.pet,
  });

  @override
  State<EditMyMissingPage> createState() => _EditMyMissingPageState();
}

class _EditMyMissingPageState extends State<EditMyMissingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController varietyNameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController missingDateController = TextEditingController();
  TextEditingController missingPlaceController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  DateTime _datetime = DateTime.now();

  String? selectedCity;
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    petNameController.text = widget.pet.petName;
    classNameController.text = widget.pet.className;
    varietyNameController.text = widget.pet.varietyName;
    sexController.text = widget.pet.petSex ? "男" : "女";
    contentController.text = widget.finding.findingContent;
    missingDateController.text = widget.finding.findingDateTime.formatDate();
    _datetime = widget.finding.findingDateTime;
    mobileController.text = widget.finding.findingMobile.toString();
    selectedCity = areaData.keys.firstWhereOrNull(
        (value) => widget.finding.findingPlace.contains(value));
    selectedDistrict = areaData[selectedCity]?.firstWhereOrNull(
        (value) => widget.finding.findingPlace.contains(value));
    if (selectedCity != null && selectedDistrict != null) {
      missingPlaceController.text = widget.finding.findingPlace
          .replaceFirst(selectedCity!, '')
          .replaceFirst(selectedDistrict!, '');
    }
  }

  Future submit() async {
    final fullAddress =
        '$selectedCity$selectedDistrict${missingPlaceController.text}';
    final findingData = {
      'Finding_ID': widget.finding.findingId,
      'Finding_MemberID': widget.finding.findingMemberId,
      'Finding_LostOrFound': widget.finding.findingLostOrFound,
      'Finding_Content': contentController.text,
      'Finding_DataTime': _datetime.toIso8601String(),
      'Finding_Place': fullAddress,
      'Finding_Image': widget.finding.findingImage,
      'Finding_PetID': widget.finding.findingPetId,
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
        title: const Text("編輯遺失資訊"),
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
                      child: widget.pet.petMugShot.isEmpty
                          ? Image.asset(AssetsImages.petPhotoPng)
                          : Image.memory(widget.pet.petMugShot),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   right: 0,
                    //   child: Container(
                    //     margin: const EdgeInsets.all(10),
                    //     height: 30,
                    //     width: 30,
                    //     decoration: const BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Colors.red,
                    //     ),
                    //     child: IconButton(
                    //       icon: const Icon(Icons.delete,
                    //           size: 15, color: Colors.white),
                    //       onPressed: () {},
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: petNameController,
                      labelText: '寵物名稱',
                      topLeftRadius: 8,
                      topRightRadius: 8,
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: classNameController,
                      labelText: '類別',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: varietyNameController,
                      labelText: '品種',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: sexController,
                      labelText: '性別',
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
                      readOnly: true,
                      controller: missingDateController,
                      validator: (value) => Validators.dateTimeValidator(value),
                      labelText: '遺失日期',
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
                                  missingDateController.text =
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
                              errorMessage: '遺失縣市',
                            ),
                            title: '遺失縣市',
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
                              errorMessage: '遺失區域',
                            ),
                            title: '遺失區域',
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
                      controller: missingPlaceController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '遺失地點',
                      ),
                      labelText: '遺失地點',
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      controller: mobileController,
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '聯絡方始',
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
