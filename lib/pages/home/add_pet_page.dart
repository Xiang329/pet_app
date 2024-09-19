import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/app_provider.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/utils/date_format_extension.dart';
import 'package:pet_app/utils/image_utils.dart';
import 'package:pet_app/utils/inv_code_generator.dart';
import 'package:pet_app/utils/validators.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  @override
  Widget build(BuildContext context) {
    return const AddPetSetp1();
  }
}

class AddPetSetp1 extends StatefulWidget {
  const AddPetSetp1({super.key});

  @override
  State<AddPetSetp1> createState() => _AddPetSetp1State();
}

class _AddPetSetp1State extends State<AddPetSetp1> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final petClassesMap = PetClassesService.petClassesMap;
  final petVarietiesMap = PetVarietiesService.petVarietyMap;
  final petVarietyMapByPcId = PetVarietiesService.petVarietyMapByPcId;

  int? selectedPetClassesId;
  int? selectedPetVarietyId;
  String? selectedPetClass;
  String? selectedPetVariety;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("新增寵物"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            padding: const EdgeInsets.fromLTRB(28, 50, 28, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownList(
                        validator: (value) => Validators.dropDownListValidator(
                          value,
                          errorMessage: '類別',
                        ),
                        width: constraints.maxWidth,
                        title: "類別",
                        items: petClassesMap.values.toList(),
                        value: selectedPetClass,
                        onChanged: (String? value) {
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
                        },
                      ),
                      const SizedBox(height: 30),
                      DropdownList(
                        validator: (value) => Validators.dropDownListValidator(
                          value,
                          errorMessage: '品種',
                        ),
                        width: constraints.maxWidth,
                        title: "品種",
                        items: petVarietyMapByPcId[selectedPetClassesId] ?? [],
                        value: selectedPetVariety,
                        onChanged: (String? value) {
                          selectedPetVarietyId = petVarietiesMap.entries
                              .firstWhere((element) =>
                                  element.value.pvVarietyName == value)
                              .key;
                          setState(() {
                            selectedPetVariety = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // const SizedBox(height: 30),
                    SizedBox(
                      height: 42,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: UiColor.theme2Color),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(context, CupertinoPageRoute<bool>(
                                builder: (BuildContext context) {
                              return AddPetSetp2(
                                selectedPetClassesId: selectedPetClassesId,
                                selectedPetVarietyId: selectedPetVarietyId,
                              );
                            }));
                          }
                        },
                        child: const Text(
                          '下一步',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AddPetSetp2 extends StatefulWidget {
  final int? selectedPetClassesId;
  final int? selectedPetVarietyId;
  const AddPetSetp2({
    super.key,
    this.selectedPetClassesId,
    this.selectedPetVarietyId,
  });

  @override
  State<AddPetSetp2> createState() => _AddPetSetp2State();
}

class _AddPetSetp2State extends State<AddPetSetp2> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController dateController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  DateTime _datetime = DateTime.now();
  Uint8List? picture;

  String? selectedWeightUnit;
  String? selectedGender;
  String? selectedLigation;

  Future submit() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final petData = {
      "Pet_ICID": "000000",
      "Pet_Name": petNameController.text,
      "Pet_BirthDay": _datetime.toIso8601String(),
      "Pet_Age": ageController.text,
      "Pet_Sex": selectedGender == "男",
      "Pet_Variety": widget.selectedPetVarietyId,
      "Pet_Weight": weightController.text,
      "Pet_Ligation": selectedLigation == "是",
      "Pet_Blood": bloodController.text,
      "Pet_MugShot": picture,
      "Pet_InvCode": generateInvCode(),
    };
    debugPrint(petData.toString());
    try {
      if (_formKey.currentState!.validate()) {
        await appProvider.addPet(petData);
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text("新增寵物"),
        leading: SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: IconButton(
            icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 30, 20, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: (picture == null)
                            ? const AssetImage(AssetsImages.petAvatorPng)
                            : MemoryImage(picture!),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
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
                OutlinedTextField(
                  labelText: "寵物名稱",
                  validator: (value) => Validators.stringValidator(
                    value,
                    errorMessage: '寵物名稱',
                  ),
                  controller: petNameController,
                ),
                const SizedBox(height: 24),
                OutlinedTextField(
                  labelText: "年紀",
                  validator: (value) => Validators.stringValidator(
                    value,
                    errorMessage: '年紀',
                    onlyInt: true,
                  ),
                  controller: ageController,
                ),
                const SizedBox(height: 24),
                OutlinedTextField(
                  readOnly: true,
                  labelText: "生日",
                  validator: (value) => Validators.dateTimeValidator(value),
                  controller: dateController,
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
                                dateController.text = datetime.formatDate();
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: OutlinedTextField(
                        labelText: "體重",
                        validator: (value) => Validators.stringValidator(
                          value,
                          errorMessage: '體重',
                          onlyInt: true,
                        ),
                        controller: weightController,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 125,
                      child: DropdownList(
                        title: "單位",
                        items: const ['公斤', '公克'],
                        value: selectedWeightUnit,
                        onChanged: (String? value) {
                          setState(
                            () {
                              if (selectedWeightUnit != value) {
                                selectedWeightUnit = value;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownList(
                  title: "性別",
                  items: const ['男', '女'],
                  validator: (value) => Validators.dropDownListValidator(
                    value,
                    errorMessage: '性別',
                  ),
                  value: selectedGender,
                  onChanged: (String? value) {
                    setState(
                      () {
                        if (selectedGender != value) {
                          selectedGender = value;
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                DropdownList(
                  title: "是否結紮",
                  items: const ['是', '否'],
                  validator: (value) => Validators.dropDownListValidator(
                    value,
                    errorMessage: '是否結紮',
                  ),
                  value: selectedLigation,
                  onChanged: (String? value) {
                    setState(
                      () {
                        if (selectedLigation != value) {
                          selectedLigation = value;
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                OutlinedTextField(
                  labelText: "血型",
                  validator: (value) => Validators.stringValidator(
                    value,
                    errorMessage: '血型',
                  ),
                  controller: bloodController,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  height: 42,
                  child: CustomButton(asyncOnPressed: submit, buttonText: '完成'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
