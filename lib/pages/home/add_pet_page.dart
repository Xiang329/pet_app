import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/common/apiMethods.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/member_provider.dart';
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
  final List<String> petCategory = [
    '狗',
    '貓',
    '鼠',
  ];
  Map<String, List<String>> petBreed = {
    "狗": ["小狗", "大狗", "狗勾"],
    "貓": ["小貓", "大貓", "喵喵"],
    "鼠": ["薯條", "薯餅", "勞薯"],
  };
  String? selectedPetCategory;
  String? selectedPetBreed;
  int? petCalssesID;
  int? petVarietyID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("新增寵物"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            // height: constraints.maxHeight,
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            padding: const EdgeInsets.fromLTRB(28, 50, 28, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownList(
                      width: constraints.maxWidth,
                      title: "類別",
                      items: petCategory,
                      value: selectedPetCategory,
                      onChanged: (String? value) {
                        petCalssesID = petCategory.indexOf(value!) + 1;
                        setState(() {
                          if (selectedPetCategory != value) {
                            // 需清空否則報錯
                            petVarietyID = null;
                            selectedPetBreed = null;
                            selectedPetCategory = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    DropdownList(
                      width: constraints.maxWidth,
                      title: "品種",
                      items: petBreed[selectedPetCategory] ?? [],
                      value: selectedPetBreed,
                      onChanged: (String? value) {
                        petVarietyID =
                            petBreed[selectedPetCategory]!.indexOf(value!) + 1;
                        setState(() {
                          selectedPetBreed = value;
                        });
                      },
                    ),
                  ],
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
                            backgroundColor: UiColor.theme2_color),
                        onPressed:
                            (petCalssesID == null || petVarietyID == null)
                                ? null
                                : () {
                                    print(petCalssesID);
                                    print(petVarietyID);
                                    Navigator.push(context,
                                        CupertinoPageRoute<bool>(
                                            builder: (BuildContext context) {
                                      return AddPetSetp2(
                                        petCalssesID: petCalssesID,
                                        petVarietyID: petVarietyID,
                                      );
                                    }));
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
  final int? petCalssesID;
  final int? petVarietyID;
  const AddPetSetp2({
    super.key,
    this.petCalssesID,
    this.petVarietyID,
  });

  @override
  State<AddPetSetp2> createState() => _AddPetSetp2State();
}

class _AddPetSetp2State extends State<AddPetSetp2> {
  TextEditingController dateController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  DateTime _datetime = DateTime.now();

  String? selectedWeightUnit;
  String? selectedGender;
  String? selectedLigation;

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("新增寵物"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 30, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(AssetsImages.dogJpg),
                      ),
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
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              OutlinedTextField(
                labelText: "寵物名稱",
                controller: petNameController,
              ),
              const SizedBox(height: 24),
              OutlinedTextField(
                labelText: "年紀",
                controller: ageController,
              ),
              const SizedBox(height: 24),
              OutlinedTextField(
                readOnly: true,
                labelText: "生日",
                controller: dateController,
                onTap: () {
                  showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        color: UiColor.theme1_color,
                        child: CupertinoDatePicker(
                          initialDateTime: _datetime,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (datetime) {
                            setState(() {
                              _datetime = datetime;
                              dateController.text = DateFormat('yyyy/MM/dd')
                                  .format(datetime)
                                  .toString();
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
                children: [
                  Expanded(
                    flex: 3,
                    child: OutlinedTextField(
                      labelText: "體重",
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
                controller: bloodController,
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: UiColor.theme2_color),
                  child: const Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    final petData = {
                      "Pet_ICID": "000000",
                      "Pet_Name": petNameController.text,
                      "Pet_BirthDay": dateController.text,
                      "Pet_Age": ageController.text,
                      "Pet_Sex": selectedGender == "男",
                      "Pet_Variety": widget.petVarietyID,
                      "Pet_Weight": weightController.text,
                      "Pet_Ligation": selectedLigation == "是",
                      "Pet_Blood": bloodController.text,
                      "Pet_MugShot": null,
                      "Pet_InvCode": "000000",
                    };
                    print(petData);
                    dynamic response =
                        await ApiMethod().postMethod('Pets', petData);
                    final petManagementData = {
                      "PM_MemberID": memberProvider.memberID,
                      "PM_PetID": response['Pet_ID'],
                      "PM_Permissions": true
                    };
                    await ApiMethod()
                        .postMethod('PetManagements', petManagementData);
                    await memberProvider.updateMember();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
