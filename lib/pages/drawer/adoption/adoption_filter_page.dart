import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/dropdown_list.dart';

class AdoptionFilterPage extends StatefulWidget {
  const AdoptionFilterPage({super.key});

  @override
  State<AdoptionFilterPage> createState() => _AdoptionFilterPageState();
}

class _AdoptionFilterPageState extends State<AdoptionFilterPage> {
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

  final List<String> shelter = [
    '收容所1',
    '收容所2',
    '收容所3',
    '收容所4',
  ];

  final List<String> petGender = [
    '男',
    '女',
  ];

  String? selectedPetCategory;
  String? selectedPetBreed;
  String? selectedShelter;
  String? selectedPetGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text("篩選"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownList(
                // width: constraints.maxWidth,
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
              const SizedBox(height: 25),
              DropdownList(
                title: "品種",
                items: petBreed[selectedPetCategory] ?? [],
                value: selectedPetBreed,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetBreed = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: "收容所",
                items: shelter,
                value: selectedShelter,
                onChanged: (String? value) {
                  setState(() {
                    selectedShelter = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: "性別",
                items: petGender,
                value: selectedPetGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetGender = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      backgroundColor:
                          MaterialStateProperty.all(UiColor.theme2_color)),
                  child: const Text(
                    '確定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    List selectedFilters = [
                      selectedPetCategory,
                      selectedPetBreed,
                      selectedShelter,
                      selectedPetGender
                    ];
                    selectedFilters.removeWhere((element) => element == null);
                    Navigator.of(context, rootNavigator: true)
                        .pop(selectedFilters);
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
