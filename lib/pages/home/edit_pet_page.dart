import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/model/pet.dart';
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

class EditPetPage extends StatefulWidget {
  final Pet pet;
  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  // TextEditingController classNameController = TextEditingController();
  // TextEditingController varietyNameController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  // TextEditingController sexController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  // TextEditingController ligationController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  DateTime _datetime = DateTime.now();
  Uint8List? picture;

  final petClassesMap = PetClassesService.petClassesMap;
  final petVarietiesMap = PetVarietiesService.petVarietyMap;
  final petVarietyMapByPcId = PetVarietiesService.petVarietyMapByPcId;

  final List<String> petGender = [
    '男',
    '女',
  ];

  int? selectedPetClassId;
  int? selectedPetVarietyId;
  String? selectedPetClass;
  String? selectedPetVariety;
  String? selectedPetSex;
  String? selectedLigation;

  @override
  void initState() {
    super.initState();
    petNameController.text = widget.pet.petName;
    ageController.text = widget.pet.petAge.toString();
    birthDayController.text = widget.pet.petBirthDay.formatDate();
    _datetime = widget.pet.petBirthDay!;
    // classNameController.text = widget.pet.className;
    // varietyNameController.text = widget.pet.varietyName;
    // sexController.text = widget.pet.petSex ? "男" : "女";
    weightController.text = widget.pet.petWeight.toString();
    // ligationController.text = widget.pet.petLigation ? "是" : "否";
    bloodController.text = widget.pet.petBlood;
    picture = widget.pet.petMugShot.isEmpty ? null : widget.pet.petMugShot;

    selectedPetClassId = petClassesMap.entries
        .firstWhereOrNull((element) => element.value == widget.pet.className)
        ?.key;
    selectedPetVarietyId = petVarietiesMap.entries
        .firstWhereOrNull(
            (element) => element.value.pvVarietyName == widget.pet.varietyName)
        ?.key;
    selectedPetClass = petClassesMap.values
        .firstWhereOrNull((value) => value.contains(widget.pet.className));
    selectedPetVariety = petVarietiesMap.values
        .firstWhereOrNull(
            (value) => value.pvVarietyName.contains(widget.pet.varietyName))
        ?.pvVarietyName;
    selectedPetSex = petGender.firstWhereOrNull(
        (value) => value.contains(widget.pet.petSex ? '男' : '女'));

    selectedLigation = widget.pet.petLigation ? '是' : '否';
  }

  Future submit() async {
    final petData = {
      "Pet_ID": widget.pet.petId,
      "Pet_ICID": widget.pet.petICID,
      "Pet_Name": petNameController.text,
      "Pet_BirthDay": _datetime.toIso8601String(),
      "Pet_Age": ageController.text,
      "Pet_Sex": selectedPetSex == '男',
      "Pet_Variety": selectedPetVarietyId,
      "Pet_Weight": weightController.text,
      "Pet_Ligation": selectedLigation == '是',
      "Pet_Blood": bloodController.text,
      "Pet_MugShot": picture,
      "Pet_InvCode": widget.pet.petInvCode,
    };
    // debugPrint(Map.from(petData).remove('Pet_MugShot'));
    try {
      if (_formKey.currentState!.validate()) {
        await Provider.of<AppProvider>(context, listen: false)
            .editPet(widget.pet.petId, petData);
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (e) {
      if (!mounted) return;
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
        backgroundColor: UiColor.theme1Color,
        title: const Text("寵物檔案"),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: (picture == null)
                          ? const AssetImage(AssetsImages.petAvatorPng)
                          : MemoryImage(picture!),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: UiColor.theme2Color,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await ImageUtils.pickImage().then((img) {
                              if (img != null) {
                                picture = img;
                                setState(() {});
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              color: UiColor.theme1Color,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledLeftLabelTextField(
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '名稱',
                      ),
                      labelText: '名稱',
                      controller: petNameController,
                    ),
                    const SizedBox(height: 10),
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
                    FilledLeftLabelTextField(
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '年紀',
                        onlyInt: true,
                      ),
                      labelText: '年紀',
                      controller: ageController,
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      readOnly: true,
                      controller: birthDayController,
                      validator: (value) => Validators.stringValidator(value),
                      labelText: '生日',
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
                                  setState(() {
                                    _datetime = datetime;
                                    birthDayController.text =
                                        datetime.formatDate();
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '體重',
                        onlyInt: true,
                      ),
                      labelText: '體重',
                      controller: weightController,
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
                    LeftLabelDropdownList(
                      validator: (value) => Validators.dropDownListValidator(
                        value,
                        errorMessage: '是否結紮',
                      ),
                      title: '是否結紮',
                      items: const ['是', '否'],
                      value: selectedLigation,
                      onChanged: (value) {
                        setState(() {
                          selectedLigation = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilledLeftLabelTextField(
                      validator: (value) => Validators.stringValidator(
                        value,
                        errorMessage: '血型',
                      ),
                      labelText: '血型',
                      controller: bloodController,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 42,
              child: CustomButton(asyncOnPressed: submit, buttonText: '完成'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
