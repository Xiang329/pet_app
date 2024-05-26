import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_app/common/app_assets.dart';
import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/widgets/dropdown_list.dart';
import 'package:pet_app/widgets/outlined_text_field.dart';

class AddMissingPage extends StatefulWidget {
  const AddMissingPage({super.key});

  @override
  State<AddMissingPage> createState() => _AddMissingPageState();
}

class _AddMissingPageState extends State<AddMissingPage> {
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

  List<String> petGender = [
    '男',
    '女',
  ];

  String? selectedPetCategory;
  String? selectedPetBreed;
  String? selectedPetGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColor.theme1_color,
      appBar: AppBar(
        backgroundColor: UiColor.theme2_color,
        title: const Text("新增遺失寵物"),
        leading: IconButton(
          icon: SvgPicture.asset(AssetsImages.arrowBackSvg),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 320,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: UiColor.navigationBar_color,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.image), Text('點擊新增圖片')],
              ),
            ),
            const SizedBox(height: 25),
            const OutlinedTextField(
              labelText: "寵物名稱",
            ),
            const SizedBox(height: 25),
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
              title: '性別',
              items: petGender,
              value: selectedPetGender,
              onChanged: (String? value) {
                setState(() {
                  selectedPetGender = value;
                });
              },
            ),
            const SizedBox(height: 25),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                labelText: "其他描述",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFB2A990)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF593922)),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 25),
            const OutlinedTextField(
              labelText: "遺失日期",
            ),
            const SizedBox(height: 25),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                labelText: "聯絡方式",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFB2A990)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF593922)),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                labelText: "聯絡資訊",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFB2A990)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF593922)),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
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
                  '發布',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
