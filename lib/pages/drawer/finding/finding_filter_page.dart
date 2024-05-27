import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/dropdown_list.dart';

class FindingFilterPage extends StatefulWidget {
  const FindingFilterPage({super.key});

  @override
  State<FindingFilterPage> createState() => _FindingFilterPageState();
}

class _FindingFilterPageState extends State<FindingFilterPage> {
  List<String> petCategory = [
    '狗',
    '貓',
    '鼠',
  ];
  Map<String, List<String>> petBreed = {
    '狗': ['小狗', '大狗', '狗勾'],
    '貓': ['小貓', '大貓', '喵喵'],
    '鼠': ['薯條', '薯餅', '勞薯'],
  };

  List<String> citys = [
    '台北市',
    '新北市',
  ];

  String? selectedPetCategory;
  String? selectedPetBreed;
  String? selectedCitys;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme1_color,
        title: const Text('篩選'),
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
                title: '類別',
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
                title: '品種',
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
                title: '縣市',
                items: citys,
                value: selectedCitys,
                onChanged: (String? value) {
                  setState(() {
                    selectedCitys = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: UiColor.theme2_color),
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
                      selectedCitys
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
