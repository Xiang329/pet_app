import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/area_data.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/add_picture.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddFoundPage extends StatefulWidget {
  const AddFoundPage({super.key});

  @override
  State<AddFoundPage> createState() => _AddFoundPageState();
}

class _AddFoundPageState extends State<AddFoundPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController foundDateController = TextEditingController();
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

  int? selectedPetClassesId;
  int? selectedPetVarietyId;
  String? selectedPetClass;
  String? selectedPetVariety;
  String? selectedPetSex;
  String? selectedCity;
  String? selectedDistrict;

  Future submit() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final fullAddress = '$selectedCity$selectedDistrict${placeController.text}';
    final findingData = {
      'Finding_MemberID': appProvider.memberId,
      'Finding_LostOrFound': false,
      'Finding_Content': contentController.text,
      'Finding_DataTime': _datetime.toIso8601String(),
      'Finding_Place': fullAddress,
      'Finding_Image': picture,
      'Finding_PetID': null,
      'Finding_PC': selectedPetClassesId,
      'Finding_PV': selectedPetVarietyId,
      "Finding_Mobile": mobileController.text,
    };
    debugPrint(findingData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await appProvider.addPetFinding(findingData);
        if (!mounted) return;
        Navigator.of(context).pop();
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
        title: const Text("新增拾獲寵物"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () async {
                  await ImageUtils.pickImage().then((img) {
                    if (img != null) {
                      picture = img;
                      setState(() {});
                    }
                  });
                },
                child: Align(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 320,
                      maxWidth: 320,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: UiColor.navigationBarColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      image: picture == null
                          ? null
                          : DecorationImage(image: MemoryImage(picture!)),
                    ),
                    child: Stack(
                      children: [
                        AddPicture(
                          visible: picture == null,
                          onTap: () async {
                            await ImageUtils.pickImage().then((img) {
                              if (img != null) {
                                picture = img;
                                setState(() {});
                              }
                            });
                          },
                        ),
                        Visibility(
                          visible: picture != null,
                          child: Positioned(
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
                                onPressed: () {
                                  setState(() {
                                    picture = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              DropdownList(
                validator: (value) => Validators.dropDownListValidator(
                  value,
                  errorMessage: '類別',
                ),
                title: '類別',
                items: petClassesMap.values.toList(),
                value: selectedPetClass,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetClassesId = petClassesMap.entries
                        .firstWhere((element) => element.value == value)
                        .key;
                    setState(() {
                      if (selectedPetClass != value) {
                        // 需清空否則報錯
                        selectedPetVarietyId = null;
                        selectedPetVariety = null;
                        selectedPetClass = value;
                      }
                    });
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                validator: (value) => Validators.dropDownListValidator(
                  value,
                  errorMessage: '品種',
                ),
                title: '品種',
                items: petVarietyMapByPcId[selectedPetClassesId] ?? [],
                value: selectedPetVariety,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetVarietyId = petVarietiesMap.entries
                        .firstWhere(
                            (element) => element.value.pvVarietyName == value)
                        .key;
                    setState(() {
                      selectedPetVariety = value;
                    });
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                validator: (value) => Validators.dropDownListValidator(
                  value,
                  errorMessage: '性別',
                ),
                title: '性別',
                items: petGender,
                value: selectedPetSex,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetSex = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: contentController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '其他描述',
                ),
                labelText: '其他描述',
                maxLines: 4,
                alignLabelWithHint: true,
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                readOnly: true,
                controller: foundDateController,
                validator: (value) => Validators.dateTimeValidator(value),
                labelText: "拾獲日期",
                onTap: () {
                  showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    context: context,
                    builder: (BuildContext context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        foundDateController.text = _datetime.formatDate();
                      });
                      return Container(
                        height: 300,
                        color: UiColor.theme1Color,
                        child: CupertinoDatePicker(
                          initialDateTime: _datetime,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (datetime) {
                            _datetime = datetime;
                            foundDateController.text = datetime.formatDate();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: DropdownList(
                      validator: (value) => Validators.dropDownListValidator(
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
                    child: DropdownList(
                      validator: (value) => Validators.dropDownListValidator(
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
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: placeController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '拾獲地點',
                ),
                labelText: '拾獲地點',
              ),
              const SizedBox(height: 25),
              OutlinedTextField(
                controller: mobileController,
                validator: (value) => Validators.stringValidator(
                  value,
                  errorMessage: '聯絡方式',
                  onlyInt: true,
                ),
                labelText: "聯絡方式",
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: CustomButton(asyncOnPressed: submit, buttonText: '發布'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
