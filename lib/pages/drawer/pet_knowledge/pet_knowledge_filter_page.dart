import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/services/pet_classes_service.dart';
import 'package:pet_app/services/pet_varieties_service.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';

class PetKnowledgeFilterPage extends StatefulWidget {
  const PetKnowledgeFilterPage({super.key});

  @override
  State<PetKnowledgeFilterPage> createState() => _PetKnowledgeFilterPageState();
}

class _PetKnowledgeFilterPageState extends State<PetKnowledgeFilterPage> {
  final petClassesMap = PetClassesService.petClassesMap;
  final petVarietiesMap = PetVarietiesService.petVarietyMapByPcId;

  int? selectedPetClassId;
  String? selectedPetClass;
  String? selectedPetVariety;

  void submit() {
    Map<String, String> selectedFilters = {
      'class': selectedPetClass ?? '',
      'variety': selectedPetVariety ?? '',
    };
    selectedFilters.removeWhere((key, value) => value.isEmpty);
    print(selectedFilters);
    Navigator.of(context, rootNavigator: true).pop(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1Color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1Color,
        title: const Text('篩選'),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownList(
                // width: constraints.maxWidth,
                title: '類別',
                items: petClassesMap.values.toList(),
                value: selectedPetClass,
                onChanged: (String? value) {
                  setState(() {
                    if (selectedPetClass != value) {
                      // 需清空否則報錯
                      selectedPetVariety = null;
                      selectedPetClass = value;
                      selectedPetClassId = petClassesMap.entries
                          .firstWhere((entry) => entry.value == value)
                          .key;
                    }
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: '品種',
                items: petVarietiesMap[selectedPetClassId] ?? [],
                value: selectedPetVariety,
                onChanged: (String? value) {
                  setState(() {
                    selectedPetVariety = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: CustomButton(syncOnPressed: submit, buttonText: '確定'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
