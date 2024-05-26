import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/models/pet.dart';
import 'package:pet_app/providers/pet_providers.dart';
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
                        setState(() {
                          if (selectedPetCategory != value) {
                            // 需清空否則報錯
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
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            backgroundColor: MaterialStateProperty.all(
                                UiColor.theme2_color)),
                        child: const Text(
                          '下一步',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute<bool>(
                              builder: (BuildContext context) {
                            return const AddPetSetp2();
                          }));
                        },
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
  const AddPetSetp2({super.key});

  @override
  State<AddPetSetp2> createState() => _AddPetSetp2State();
}

class _AddPetSetp2State extends State<AddPetSetp2> {
  String? selectedWeightUnit;
  String? selectedGender;
  String? selectedLigation;

  void _addPet() {
    setState(() {
      int number = Random().nextInt(10);
      Provider.of<PetsProvider>(context, listen: false)
          .insertPet(0, Pet("新增的寵物_$number", 99, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text(
          "新增寵物",
          style: TextStyle(
            color: UiColor.text1_color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
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
              const OutlinedTextField(
                labelText: "寵物名稱",
              ),
              const SizedBox(height: 24),
              const OutlinedTextField(
                labelText: "年紀",
              ),
              const SizedBox(height: 24),
              const OutlinedTextField(
                labelText: "生日",
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: OutlinedTextField(
                      labelText: "體重",
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
              const OutlinedTextField(
                labelText: "血型",
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      backgroundColor:
                          MaterialStateProperty.all(UiColor.theme2_color)),
                  child: const Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _addPet();
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
