import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/common/area_data.dart';
import 'package:pet_app/widgets/custom_button.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/left_label_dropdown_list.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  String? selectedCitys;
  String? selectedDistrict;

  void submit() {
    Map<String, String> selectedFilters = {
      'city': selectedCitys ?? '',
      'district': selectedDistrict ?? '',
    };
    selectedFilters.removeWhere((key, value) => value.isEmpty);
    debugPrint(selectedFilters.toString());
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LeftLabelDropdownList(
                title: '縣市',
                items: areaData.keys.toList(),
                value: selectedCitys,
                onChanged: (String? value) {
                  setState(() {
                    selectedDistrict = null;
                    selectedCitys = value;
                  });
                },
              ),
              DropdownList(
                title: '縣市',
                items: areaData.keys.toList(),
                value: selectedCitys,
                onChanged: (String? value) {
                  setState(() {
                    selectedDistrict = null;
                    selectedCitys = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              DropdownList(
                title: '區域',
                items: areaData[selectedCitys] ?? [],
                value: selectedDistrict,
                onChanged: (String? value) {
                  setState(() {
                    selectedDistrict = value;
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
